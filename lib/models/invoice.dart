import 'package:appocrm/models/invoice_status.dart';

class Invoice {
  Invoice({
    this.id,
    required this.contactId,
    required this.invoiceNumber,
    required this.title,
    required this.amount,
    this.currency = 'INR',
    this.status = InvoiceStatus.draft,
    this.notes,
    required this.createdAt,
    this.dueAt,
    this.paidAt,
  });

  final int? id;
  final int contactId;
  final String invoiceNumber;
  final String title;
  final double amount;
  final String currency;
  final InvoiceStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? dueAt;
  final DateTime? paidAt;

  Invoice copyWith({
    int? id,
    int? contactId,
    String? invoiceNumber,
    String? title,
    double? amount,
    String? currency,
    InvoiceStatus? status,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? dueAt,
    bool clearDueAt = false,
    DateTime? paidAt,
    bool clearPaidAt = false,
  }) {
    return Invoice(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      dueAt: clearDueAt ? null : (dueAt ?? this.dueAt),
      paidAt: clearPaidAt ? null : (paidAt ?? this.paidAt),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'contact_id': contactId,
      'invoice_number': invoiceNumber,
      'title': title,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'notes': notes,
      'created_at': createdAt.millisecondsSinceEpoch,
      'due_at': dueAt?.millisecondsSinceEpoch,
      'paid_at': paidAt?.millisecondsSinceEpoch,
    };
  }

  factory Invoice.fromMap(Map<String, Object?> map) {
    return Invoice(
      id: map['id'] as int?,
      contactId: map['contact_id'] as int,
      invoiceNumber: map['invoice_number'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String? ?? 'INR',
      status: InvoiceStatus.fromDb(map['status'] as String),
      notes: map['notes'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      dueAt: map['due_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['due_at'] as int)
          : null,
      paidAt: map['paid_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['paid_at'] as int)
          : null,
    );
  }
}
