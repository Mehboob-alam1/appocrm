import 'package:appocrm/models/call_disposition.dart';
import 'package:appocrm/services/after_call_prompt_service.dart';
import 'package:flutter/material.dart';

typedef AfterCallOutcomeResult = ({
  CallDisposition disposition,
  bool openVoiceNote,
  bool openTextNote,
});

Future<AfterCallOutcomeResult?> showAfterCallOutcomeSheet(
  BuildContext context,
  AfterCallPromptTarget target,
) {
  return showModalBottomSheet<AfterCallOutcomeResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      CallDisposition? selected;
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Call with ${target.contactName}',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'How did it go? (NeoDove-style outcome)',
                    style: Theme.of(ctx).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: CallDisposition.values.map((d) {
                      final isSelected = selected == d;
                      return ChoiceChip(
                        label: Text(d.label),
                        selected: isSelected,
                        onSelected: (_) => setState(() => selected = d),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: selected == null
                        ? null
                        : () {
                            Navigator.pop(
                              ctx,
                              (
                                disposition: selected!,
                                openVoiceNote: true,
                                openTextNote: false,
                              ),
                            );
                          },
                    child: const Text('Save outcome & voice note'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: selected == null
                        ? null
                        : () {
                            Navigator.pop(
                              ctx,
                              (
                                disposition: selected!,
                                openVoiceNote: false,
                                openTextNote: true,
                              ),
                            );
                          },
                    child: const Text('Save outcome & text note'),
                  ),
                  TextButton(
                    onPressed: selected == null
                        ? null
                        : () {
                            Navigator.pop(
                              ctx,
                              (
                                disposition: selected!,
                                openVoiceNote: false,
                                openTextNote: false,
                              ),
                            );
                          },
                    child: const Text('Save outcome only'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
