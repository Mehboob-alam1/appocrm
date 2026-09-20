import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/models/contact.dart';
import 'package:appocrm/models/note.dart';
import 'package:appocrm/models/pipeline_status.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:appocrm/utils/launchers.dart';
import 'package:appocrm/widgets/app_card.dart';
import 'package:appocrm/widgets/contact_avatar.dart';
import 'package:appocrm/widgets/contact_tile.dart';
import 'package:appocrm/widgets/pipeline_selector.dart';
import 'package:appocrm/widgets/quick_actions.dart';
import 'package:appocrm/widgets/voice_note_capture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({
    super.key,
    required this.repository,
    required this.contactId,
  });

  final CrmRepository repository;
  final int contactId;

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  Contact? _contact;
  List<Note> _notes = [];
  int _callCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final contact = await widget.repository.getContact(widget.contactId);
    final notes = await widget.repository.getNotesForContact(widget.contactId);
    final calls = await widget.repository.getCallLogsForContact(widget.contactId);
    if (mounted) {
      setState(() {
        _contact = contact;
        _notes = notes;
        _callCount = calls.length;
        _loading = false;
      });
    }
  }

  Future<void> _updateContact(Contact updated) async {
    await widget.repository.updateContact(updated);
    await _load();
  }

  Future<void> _saveVoiceNote(String text) async {
    final contact = _contact;
    if (contact == null || contact.id == null) return;
    await widget.repository.insertNote(
      Note(
        contactId: contact.id!,
        body: text,
        fromVoice: true,
        createdAt: DateTime.now(),
      ),
    );
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice note saved')),
      );
    }
  }

  Future<void> _logCall() async {
    await widget.repository.logCall(widget.contactId);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Call logged')),
      );
    }
  }

  Future<void> _pickFollowUpDate() async {
    final contact = _contact;
    if (contact == null) return;
    final initial = contact.followUpAt ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(contact.followUpAt ?? DateTime.now()),
    );

    var followUp = DateTime(picked.year, picked.month, picked.day);
    if (time != null) {
      followUp = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
    }

    await _updateContact(
      contact.copyWith(
        followUpAt: followUp,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _clearFollowUp() async {
    final contact = _contact;
    if (contact == null) return;
    await _updateContact(
      contact.copyWith(clearFollowUpAt: true, updatedAt: DateTime.now()),
    );
  }

  Future<void> _onPipelineChanged(PipelineStatus status) async {
    final contact = _contact;
    if (contact == null) return;
    var updated = contact.copyWith(pipeline: status, updatedAt: DateTime.now());
    if (status == PipelineStatus.followUp && contact.followUpAt == null) {
      updated = updated.copyWith(
        followUpAt: DateTime.now().add(const Duration(hours: 2)),
      );
    }
    await _updateContact(updated);
  }

  Future<void> _deleteContact() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete contact?'),
        content: const Text('Notes and call history will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await widget.repository.deleteContact(widget.contactId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final contact = _contact;
    if (contact == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Contact not found')),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _deleteContact,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          AppCard(
            child: Column(
              children: [
                ContactAvatar(
                  name: contact.name,
                  pipeline: contact.pipeline,
                  large: true,
                ),
                const SizedBox(height: 14),
                Text(contact.name, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(contact.phone, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 10),
                PipelineBadge(status: contact.pipeline),
                const SizedBox(height: 8),
                Text(
                  '$_callCount calls logged',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              QuickActionButton(
                icon: Icons.call_rounded,
                label: 'Call',
                onPressed: () => launchPhoneCall(contact.phone),
              ),
              const SizedBox(width: 10),
              QuickActionButton(
                icon: Icons.history_rounded,
                label: 'Log',
                onPressed: _logCall,
              ),
              const SizedBox(width: 10),
              QuickActionButton(
                icon: Icons.chat_rounded,
                label: 'WhatsApp',
                onPressed: () => launchWhatsAppChat(contact.phone),
                highlight: true,
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'Pipeline'),
          const SizedBox(height: 10),
          PipelineSelector(value: contact.pipeline, onChanged: _onPipelineChanged),
          const SizedBox(height: 18),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Follow-up', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        contact.followUpAt != null
                            ? DateFormat.yMMMd().add_jm().format(contact.followUpAt!)
                            : 'No date set',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: _pickFollowUpDate, child: const Text('Set')),
                if (contact.followUpAt != null)
                  TextButton(onPressed: _clearFollowUp, child: const Text('Clear')),
              ],
            ),
          ),
          const SizedBox(height: 18),
          VoiceNoteCapture(onSaved: _saveVoiceNote),
          const SizedBox(height: 22),
          SectionHeader(
            title: 'Notes',
            subtitle: _notes.isEmpty ? null : '${_notes.length} saved',
          ),
          const SizedBox(height: 10),
          if (_notes.isEmpty)
            AppCard(
              child: Text(
                'No notes yet. Record a voice note after your next call.',
                style: theme.textTheme.bodyMedium,
              ),
            )
          else
            ..._notes.map(
              (note) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (note.fromVoice
                                  ? AppColors.accentVoice
                                  : AppColors.primary)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          note.fromVoice ? Icons.mic_rounded : Icons.notes_rounded,
                          size: 18,
                          color: note.fromVoice ? AppColors.accentVoice : AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note.body, style: theme.textTheme.bodyLarge),
                            const SizedBox(height: 6),
                            Text(
                              DateFormat.yMMMd().add_jm().format(note.createdAt),
                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
