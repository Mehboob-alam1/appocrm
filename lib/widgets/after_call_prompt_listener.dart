import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/navigation/app_navigator.dart';
import 'package:appocrm/screens/contact_detail_screen.dart';
import 'package:appocrm/services/after_call_prompt_service.dart';
import 'package:appocrm/widgets/after_call_outcome_sheet.dart';
import 'package:flutter/material.dart';

/// Listens for app resume after an outbound call and shows outcome + note flow.
class AfterCallPromptListener extends StatefulWidget {
  const AfterCallPromptListener({
    super.key,
    required this.repository,
    required this.child,
  });

  final CrmRepository repository;
  final Widget child;

  @override
  State<AfterCallPromptListener> createState() => _AfterCallPromptListenerState();
}

class _AfterCallPromptListenerState extends State<AfterCallPromptListener>
    with WidgetsBindingObserver {
  final _prompts = AfterCallPromptService.instance;
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _prompts.onAppPaused();
    }
    if (state == AppLifecycleState.resumed) {
      _maybeShowPrompt();
    }
  }

  Future<void> _maybeShowPrompt() async {
    if (_sheetOpen) return;
    final target = _prompts.consumeOnResume();
    if (target == null) return;

    final nav = appNavigatorKey.currentState;
    if (nav == null || !nav.mounted) return;

    _sheetOpen = true;
    final result = await showAfterCallOutcomeSheet(nav.context, target);
    _sheetOpen = false;

    if (result == null) return;

    await widget.repository.setCallDisposition(
      target.callLogId,
      result.disposition,
    );
    final contact = await widget.repository.getContact(target.contactId);
    if (contact != null) {
      await widget.repository.applyDispositionSideEffects(
        contact: contact,
        disposition: result.disposition,
      );
    }

    if (result.openVoiceNote || result.openTextNote) {
      await _openContact(
        target.contactId,
        autoStartVoiceNote: result.openVoiceNote,
        focusTextNote: result.openTextNote,
      );
    }
  }

  Future<void> _openContact(
    int contactId, {
    bool autoStartVoiceNote = false,
    bool focusTextNote = false,
  }) async {
    final nav = appNavigatorKey.currentState;
    if (nav == null) return;
    await nav.push(
      MaterialPageRoute<void>(
        builder: (_) => ContactDetailScreen(
          repository: widget.repository,
          contactId: contactId,
          autoStartVoiceNote: autoStartVoiceNote,
          focusTextNote: focusTextNote,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
