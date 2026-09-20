import 'package:appocrm/models/contact.dart';
import 'package:appocrm/models/pipeline_status.dart';
import 'package:appocrm/utils/follow_up.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('contact with past follow-up date is due', () {
    final now = DateTime(2026, 3, 10, 15);
    final contact = Contact(
      id: 1,
      name: 'Ramesh',
      phone: '+919999999999',
      pipeline: PipelineStatus.confirmed,
      followUpAt: DateTime(2026, 3, 9),
      createdAt: now,
      updatedAt: now,
    );
    expect(isDueForFollowUp(contact, now), isTrue);
  });

  test('follow-up pipeline without date is due', () {
    final now = DateTime(2026, 3, 10);
    final contact = Contact(
      id: 1,
      name: 'Ramesh',
      phone: '+919999999999',
      pipeline: PipelineStatus.followUp,
      createdAt: now,
      updatedAt: now,
    );
    expect(isDueForFollowUp(contact, now), isTrue);
  });

  test('future follow-up is not due', () {
    final now = DateTime(2026, 3, 10);
    final contact = Contact(
      id: 1,
      name: 'Ramesh',
      phone: '+919999999999',
      pipeline: PipelineStatus.lead,
      followUpAt: DateTime(2026, 3, 15),
      createdAt: now,
      updatedAt: now,
    );
    expect(isDueForFollowUp(contact, now), isFalse);
  });
}
