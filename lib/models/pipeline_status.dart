enum PipelineStatus {
  lead,
  followUp,
  confirmed,
  paid;

  String get label {
    switch (this) {
      case PipelineStatus.lead:
        return 'Lead';
      case PipelineStatus.followUp:
        return 'Follow-up';
      case PipelineStatus.confirmed:
        return 'Confirmed';
      case PipelineStatus.paid:
        return 'Paid';
    }
  }

  static PipelineStatus fromDb(String value) {
    return PipelineStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PipelineStatus.lead,
    );
  }
}
