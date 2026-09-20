class Note {
  Note({
    this.id,
    required this.contactId,
    required this.body,
    required this.fromVoice,
    required this.createdAt,
  });

  final int? id;
  final int contactId;
  final String body;
  final bool fromVoice;
  final DateTime createdAt;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'contact_id': contactId,
      'body': body,
      'from_voice': fromVoice ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'] as int?,
      contactId: map['contact_id'] as int,
      body: map['body'] as String,
      fromVoice: (map['from_voice'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }
}
