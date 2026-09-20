import 'package:appocrm/utils/launchers.dart';
import 'package:appocrm/utils/whatsapp_templates.dart';
import 'package:flutter/material.dart';

Future<void> openWhatsAppWithTemplatePicker(
  BuildContext context,
  String phone,
) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'WhatsApp message',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Pick a template (NeoDove-style). You can edit it in WhatsApp before sending.',
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text('Open without message'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await launchWhatsAppChat(phone);
                },
              ),
              ...whatsAppTemplates.entries.map(
                (e) => ListTile(
                  leading: const Icon(Icons.quickreply_outlined),
                  title: Text(e.key),
                  subtitle: Text(
                    e.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await launchWhatsAppChat(phone, message: e.value);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
