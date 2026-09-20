import 'package:appocrm/services/after_call_prompt_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no prompt if user never left the app', () {
    final service = AfterCallPromptService.instance;
    service.cancelPending();
    service.markCallStarted(contactId: 1, contactName: 'Ramesh', callLogId: 10);
    expect(service.consumeOnResume(), isNull);
  });

  test('prompt after leaving app and short wait', () async {
    final service = AfterCallPromptService.instance;
    service.cancelPending();
    service.markCallStarted(contactId: 2, contactName: 'Priya', callLogId: 11);
    service.onAppPaused();
    await Future<void>.delayed(const Duration(milliseconds: 3100));
    final target = service.consumeOnResume();
    expect(target, isNotNull);
    expect(target!.contactId, 2);
    expect(service.consumeOnResume(), isNull);
  });
}
