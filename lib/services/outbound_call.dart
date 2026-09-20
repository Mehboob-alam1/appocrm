import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/models/contact.dart';
import 'package:appocrm/services/after_call_prompt_service.dart';
import 'package:appocrm/utils/launchers.dart';

/// NeoDove-style: tap Call → log starts → dialer opens → outcome on return.
Future<void> startOutboundCall(CrmRepository repository, Contact contact) async {
  if (contact.id == null) return;
  final callLogId = await repository.logCall(contact.id!);
  AfterCallPromptService.instance.markCallStarted(
    contactId: contact.id!,
    contactName: contact.name,
    callLogId: callLogId,
  );
  await launchPhoneCall(contact.phone);
}
