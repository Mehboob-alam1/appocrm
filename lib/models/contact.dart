import 'package:appocrm/models/pipeline_status.dart';

class Contact {
  Contact({
    this.id,
    required this.name,
    required this.phone,
    this.pipeline = PipelineStatus.lead,
    this.followUpAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String name;
  final String phone;
  final PipelineStatus pipeline;
  final DateTime? followUpAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    PipelineStatus? pipeline,
    DateTime? followUpAt,
    bool clearFollowUpAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      pipeline: pipeline ?? this.pipeline,
      followUpAt: clearFollowUpAt ? null : (followUpAt ?? this.followUpAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'pipeline': pipeline.name,
      'follow_up_at': followUpAt?.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Contact.fromMap(Map<String, Object?> map) {
    return Contact(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      pipeline: PipelineStatus.fromDb(map['pipeline'] as String),
      followUpAt: map['follow_up_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['follow_up_at'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
