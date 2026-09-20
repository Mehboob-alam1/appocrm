import 'package:appocrm/data/app_database.dart';
import 'package:appocrm/models/call_log_entry.dart';
import 'package:appocrm/models/contact.dart';
import 'package:appocrm/models/note.dart';
import 'package:appocrm/models/pipeline_status.dart';
import 'package:appocrm/utils/follow_up.dart';
import 'package:sqflite/sqflite.dart';

class CrmRepository {
  CrmRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

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

  Future<Contact?> getContact(int id) async {
    final db = await _db;
    final rows = await db.query('contacts', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Contact.fromMap(rows.first);
  }

  Future<int> insertContact(Contact contact) async {
    final db = await _db;
    return db.insert('contacts', contact.toMap()..remove('id'));
  }

  Future<void> updateContact(Contact contact) async {
    final db = await _db;
    await db.update(
      'contacts',
      contact.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await _db;
    await db.delete('notes', where: 'contact_id = ?', whereArgs: [id]);
    await db.delete('call_logs', where: 'contact_id = ?', whereArgs: [id]);
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
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
}
