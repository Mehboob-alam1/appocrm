/// Tracks an outbound call so we can prompt for a note when the user returns.
class AfterCallPromptTarget {
  AfterCallPromptTarget({
    required this.contactId,
    required this.contactName,
    required this.startedAt,
    required this.callLogId,
  });

  final int contactId;
  final String contactName;
  final DateTime startedAt;
  final int callLogId;
}

class AfterCallPromptService {
  AfterCallPromptService._();

  static final AfterCallPromptService instance = AfterCallPromptService._();

  AfterCallPromptTarget? _pending;
  bool _leftAppSincePending = false;

  void markCallStarted({
    required int contactId,
    required String contactName,
    required int callLogId,
  }) {
    _pending = AfterCallPromptTarget(
      contactId: contactId,
      contactName: contactName,
      startedAt: DateTime.now(),
      callLogId: callLogId,
    );
    _leftAppSincePending = false;
  }

  void onAppPaused() {
    if (_pending != null) {
      _leftAppSincePending = true;
    }
  }

  /// Returns a target once when the user comes back after leaving for the call.
  AfterCallPromptTarget? consumeOnResume() {
    final pending = _pending;
    if (pending == null || !_leftAppSincePending) return null;

    final elapsed = DateTime.now().difference(pending.startedAt);
    _pending = null;
    _leftAppSincePending = false;

    if (elapsed < const Duration(seconds: 3)) return null;
    if (elapsed > const Duration(hours: 4)) return null;

    return pending;
  }

  void cancelPending() {
    _pending = null;
    _leftAppSincePending = false;
  }
}
