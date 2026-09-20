class CallLogEntry {
  CallLogEntry({
    this.id,
    required this.contactId,
    required this.createdAt,
  });

  final int? id;
  final int contactId;
  final DateTime createdAt;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'contact_id': contactId,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CallLogEntry.fromMap(Map<String, Object?> map) {
    return CallLogEntry(
      id: map['id'] as int?,
      contactId: map['contact_id'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }
}
