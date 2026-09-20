import 'package:appocrm/models/call_disposition.dart';

class CallLogEntry {
  CallLogEntry({
    this.id,
    required this.contactId,
    required this.createdAt,
    this.disposition,
  });

  final int? id;
  final int contactId;
  final DateTime createdAt;
  final CallDisposition? disposition;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'contact_id': contactId,
      'created_at': createdAt.millisecondsSinceEpoch,
      'disposition': disposition?.name,
    };
  }

  factory CallLogEntry.fromMap(Map<String, Object?> map) {
    return CallLogEntry(
      id: map['id'] as int?,
      contactId: map['contact_id'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      disposition: CallDisposition.fromDb(map['disposition'] as String?),
    );
  }
}
