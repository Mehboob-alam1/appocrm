import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/screens/privacy_policy_screen.dart';
import 'package:appocrm/services/export_service.dart';
import 'package:appocrm/services/follow_up_notifications.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:appocrm/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Replace with your Google Form when running Phase 2 beta.
const betaFeedbackFormUrl =
    'https://docs.google.com/forms/d/e/REPLACE_WITH_YOUR_FORM/viewform';

const kAppVersionLabel = '0.2.0+2';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.repository});

  final CrmRepository repository;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _export() async {
    try {
      await ExportService(widget.repository).shareContactsCsv();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  Future<void> _enableNotifications() async {
    final ok = await FollowUpNotificationService.instance.requestPermission();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Notifications enabled' : 'Notification permission not granted',
        ),
      ),
    );
    if (ok) {
      await FollowUpNotificationService.instance.syncAll(widget.repository);
    }
  }

  Future<void> _openFeedback() async {
    final uri = Uri.parse(betaFeedbackFormUrl);
    if (betaFeedbackFormUrl.contains('REPLACE')) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add your Google Form URL in lib/screens/settings_screen.dart'),
        ),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text('More', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('Beta tools & data', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 20),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SettingsTile(
                icon: Icons.notifications_active_outlined,
                title: 'Follow-up reminders',
                subtitle: 'Allow alerts when a follow-up time arrives',
                onTap: _enableNotifications,
              ),
              const Divider(height: 24),
              _SettingsTile(
                icon: Icons.upload_file_outlined,
                title: 'Export contacts (CSV)',
                subtitle: 'Share a backup file—still 100% local',
                onTap: _export,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SettingsTile(
                icon: Icons.rate_review_outlined,
                title: 'Beta feedback',
                subtitle: 'Tell us what broke or confused you',
                onTap: _openFeedback,
              ),
              const Divider(height: 24),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy policy',
                subtitle: 'How your data is stored on-device',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Appomatrix CRM · v$kAppVersionLabel (beta)',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
