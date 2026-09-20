import 'package:appocrm/models/pipeline_status.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PipelineSelector extends StatelessWidget {
  const PipelineSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final PipelineStatus value;
  final ValueChanged<PipelineStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PipelineStatus.values.map((status) {
        final selected = status == value;
        final color = pipelineColor(status);
        return Material(
          color: selected ? color.withValues(alpha: 0.14) : AppColors.surface,
          shape: StadiumBorder(
            side: BorderSide(
              color: selected ? color : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => onChanged(status),
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                status.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: selected ? color : AppColors.textSecondary,
                      fontSize: 13,
                    ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

Color pipelineColor(PipelineStatus status) {
  switch (status) {
    case PipelineStatus.lead:
      return const Color(0xFF5C6B7A);
    case PipelineStatus.followUp:
      return const Color(0xFFC45C26);
    case PipelineStatus.confirmed:
      return const Color(0xFF0D5C4F);
    case PipelineStatus.paid:
      return const Color(0xFF2F7A3E);
  }
}
