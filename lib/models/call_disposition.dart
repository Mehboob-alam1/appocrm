enum CallDisposition {
  connected,
  noAnswer,
  busy,
  callback,
  wrongNumber;

  String get label {
    switch (this) {
      case CallDisposition.connected:
        return 'Connected';
      case CallDisposition.noAnswer:
        return 'No answer';
      case CallDisposition.busy:
        return 'Busy';
      case CallDisposition.callback:
        return 'Callback later';
      case CallDisposition.wrongNumber:
        return 'Wrong number';
    }
  }

  static CallDisposition? fromDb(String? value) {
    if (value == null || value.isEmpty) return null;
    return CallDisposition.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CallDisposition.connected,
    );
  }
}
