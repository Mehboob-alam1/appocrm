import 'package:appocrm/models/contact.dart';
import 'package:appocrm/models/pipeline_status.dart';

/// End of local calendar day for [day].
DateTime endOfDay(DateTime day) {
  return DateTime(day.year, day.month, day.day, 23, 59, 59, 999);
}

bool isDueForFollowUp(Contact contact, DateTime now) {
  final due = contact.followUpAt;
  if (due == null) {
    return contact.pipeline == PipelineStatus.followUp;
  }
  return !due.isAfter(endOfDay(now));
}

List<Contact> sortFollowUps(List<Contact> contacts, DateTime now) {
  final due = contacts.where((c) => isDueForFollowUp(c, now)).toList()
    ..sort((a, b) {
      final aDue = a.followUpAt;
      final bDue = b.followUpAt;
      if (aDue == null && bDue == null) return a.name.compareTo(b.name);
      if (aDue == null) return 1;
      if (bDue == null) return -1;
      return aDue.compareTo(bDue);
    });
  return due;
}
