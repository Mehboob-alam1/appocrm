import 'package:appocrm/models/contact.dart';
import 'package:appocrm/models/pipeline_status.dart';
import 'package:appocrm/widgets/app_card.dart';
import 'package:appocrm/widgets/contact_avatar.dart';
import 'package:appocrm/widgets/pipeline_selector.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
    required this.onTap,
    this.subtitle,
    this.trailing,
  });

  final Contact contact;
  final VoidCallback onTap;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = subtitle ?? contact.phone;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            ContactAvatar(name: contact.name, pipeline: contact.pipeline),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    line,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PipelineBadge(status: contact.pipeline),
            const SizedBox(width: 4),
            trailing ?? Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class PipelineBadge extends StatelessWidget {
  const PipelineBadge({super.key, required this.status});

  final PipelineStatus status;

  @override
  Widget build(BuildContext context) {
    final color = pipelineColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontSize: 11,
            ),
      ),
    );
  }
}
