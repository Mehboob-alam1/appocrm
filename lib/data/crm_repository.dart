import 'package:appocrm/data/app_database.dart';
import 'package:appocrm/models/call_disposition.dart';
import 'package:appocrm/models/call_log_entry.dart';
import 'package:appocrm/models/contact.dart';
import 'package:appocrm/models/invoice.dart';
import 'package:appocrm/models/invoice_status.dart';
import 'package:appocrm/models/note.dart';
import 'package:appocrm/models/pipeline_status.dart';
import 'package:appocrm/services/follow_up_notifications.dart';
import 'package:appocrm/utils/follow_up.dart';
import 'package:sqflite/sqflite.dart';

class CrmRepository {
  CrmRepository({
    AppDatabase? database,
    FollowUpNotificationService? notifications,
  })  : _database = database ?? AppDatabase.instance,
        _notifications = notifications;

  final AppDatabase _database;
  final FollowUpNotificationService? _notifications;

  Future<Database> get _db => _database.database;

  Future<List<Contact>> getAllContacts() async {
    final db = await _db;
    final rows = await db.query('contacts', orderBy: 'name COLLATE NOCASE ASC');
    return rows.map(Contact.fromMap).toList();
  }

  Future<List<Contact>> getFollowUpsDue({DateTime? asOf}) async {
    final now = asOf ?? DateTime.now();
    final all = await getAllContacts();
    return sortFollowUps(all, now);
  }

  /// NeoDove-style solo dial queue: leads + follow-ups to work top-down.
  Future<List<Contact>> getCallQueue({DateTime? asOf}) async {
    final now = asOf ?? DateTime.now();
    final all = await getAllContacts();
    final queue = all.where((c) {
      if (isDueForFollowUp(c, now)) return true;
      return c.pipeline == PipelineStatus.lead ||
          c.pipeline == PipelineStatus.followUp;
    }).toList()
      ..sort((a, b) {
        final aDue = isDueForFollowUp(a, now);
        final bDue = isDueForFollowUp(b, now);
        if (aDue != bDue) return aDue ? -1 : 1;
        final af = a.followUpAt;
        final bf = b.followUpAt;
        if (af != null && bf != null) return af.compareTo(bf);
        if (af != null) return -1;
        if (bf != null) return 1;
        return a.name.compareTo(b.name);
      });
    return queue;
  }

  Future<Contact?> getContact(int id) async {
    final db = await _db;
    final rows = await db.query('contacts', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Contact.fromMap(rows.first);
  }

  Future<int> insertContact(Contact contact) async {
    final db = await _db;
    final id = await db.insert('contacts', contact.toMap()..remove('id'));
    final saved = contact.copyWith(id: id);
    await _notifications?.scheduleForContact(saved);
    return id;
  }

  Future<void> updateContact(Contact contact) async {
    final db = await _db;
    await db.update(
      'contacts',
      contact.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
    await _notifications?.scheduleForContact(contact);
  }

  Future<void> deleteContact(int id) async {
    final db = await _db;
    await db.delete('notes', where: 'contact_id = ?', whereArgs: [id]);
    await db.delete('invoices', where: 'contact_id = ?', whereArgs: [id]);
    await db.delete('call_logs', where: 'contact_id = ?', whereArgs: [id]);
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
    await _notifications?.cancelForContact(id);
  }

  Future<List<Note>> getNotesForContact(int contactId) async {
    final db = await _db;
    final rows = await db.query(
      'notes',
      where: 'contact_id = ?',
      whereArgs: [contactId],
      orderBy: 'created_at DESC',
    );
    return rows.map(Note.fromMap).toList();
  }

  Future<int> insertNote(Note note) async {
    final db = await _db;
    return db.insert('notes', note.toMap()..remove('id'));
  }

  Future<List<CallLogEntry>> getCallLogsForContact(int contactId) async {
    final db = await _db;
    final rows = await db.query(
      'call_logs',
      where: 'contact_id = ?',
      whereArgs: [contactId],
      orderBy: 'created_at DESC',
    );
    return rows.map(CallLogEntry.fromMap).toList();
  }

  Future<int> logCall(int contactId) async {
    final db = await _db;
    final now = DateTime.now();
    return db.insert('call_logs', {
      'contact_id': contactId,
      'created_at': now.millisecondsSinceEpoch,
    });
  }

  Future<void> setCallDisposition(int callLogId, CallDisposition disposition) async {
    final db = await _db;
    await db.update(
      'call_logs',
      {'disposition': disposition.name},
      where: 'id = ?',
      whereArgs: [callLogId],
    );
  }

  Future<void> applyDispositionSideEffects({
    required Contact contact,
    required CallDisposition disposition,
  }) async {
    var updated = contact;
    final now = DateTime.now();

    switch (disposition) {
      case CallDisposition.noAnswer:
      case CallDisposition.busy:
        final tomorrow = now.add(const Duration(days: 1));
        updated = contact.copyWith(
          pipeline: PipelineStatus.followUp,
          followUpAt: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10),
          updatedAt: now,
        );
      case CallDisposition.callback:
        updated = contact.copyWith(
          pipeline: PipelineStatus.followUp,
          followUpAt: now.add(const Duration(hours: 4)),
          updatedAt: now,
        );
      case CallDisposition.connected:
        updated = contact.copyWith(updatedAt: now);
      case CallDisposition.wrongNumber:
        updated = contact.copyWith(
          pipeline: PipelineStatus.lead,
          updatedAt: now,
        );
    }
    if (updated.id != null) {
      await updateContact(updated);
    }
  }

  Future<Contact> upsertFromPhoneBook({
    required String name,
    required String phone,
  }) async {
    final normalized = _normalizePhone(phone);
    final db = await _db;
    final existing = await db.query(
      'contacts',
      where: 'phone = ?',
      whereArgs: [normalized],
      limit: 1,
    );
    final now = DateTime.now();
    if (existing.isNotEmpty) {
      return Contact.fromMap(existing.first);
    }
    final contact = Contact(
      name: name.trim(),
      phone: normalized,
      pipeline: PipelineStatus.lead,
      createdAt: now,
      updatedAt: now,
    );
    final id = await insertContact(contact);
    return contact.copyWith(id: id);
  }

  String _normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '').trim();
  }

  Future<String> nextInvoiceNumber(int contactId) async {
    final db = await _db;
    final count = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM invoices WHERE contact_id = ?',
            [contactId],
          ),
        ) ??
        0;
    final seq = count + 1;
    final stamp = DateTime.now().year;
    return 'INV-$stamp-${contactId.toString().padLeft(4, '0')}-${seq.toString().padLeft(3, '0')}';
  }

  Future<List<Invoice>> getInvoicesForContact(int contactId) async {
    final db = await _db;
    final rows = await db.query(
      'invoices',
      where: 'contact_id = ?',
      whereArgs: [contactId],
      orderBy: 'created_at DESC',
    );
    return rows.map(Invoice.fromMap).toList();
  }

  Future<int> insertInvoice(Invoice invoice) async {
    final db = await _db;
    return db.insert('invoices', invoice.toMap()..remove('id'));
  }

  Future<void> updateInvoice(Invoice invoice) async {
    final db = await _db;
    await db.update(
      'invoices',
      invoice.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<void> deleteInvoice(int invoiceId) async {
    final db = await _db;
    await db.delete('invoices', where: 'id = ?', whereArgs: [invoiceId]);
  }

  Future<void> markInvoicePaid(int invoiceId, {required int contactId}) async {
    final db = await _db;
    final now = DateTime.now();
    await db.update(
      'invoices',
      {
        'status': InvoiceStatus.paid.name,
        'paid_at': now.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [invoiceId],
    );
    final contact = await getContact(contactId);
    if (contact != null && contact.pipeline != PipelineStatus.paid) {
      await updateContact(
        contact.copyWith(pipeline: PipelineStatus.paid, updatedAt: now),
      );
    }
  }
}
