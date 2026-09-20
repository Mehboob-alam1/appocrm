import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/models/contact.dart';
import 'package:appocrm/screens/contact_detail_screen.dart';
import 'package:appocrm/services/outbound_call.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:appocrm/widgets/app_card.dart';
import 'package:appocrm/widgets/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  final CrmRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> _due = [];
  List<Contact> _queue = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final due = await widget.repository.getFollowUpsDue();
    final queue = await widget.repository.getCallQueue();
    if (mounted) {
      setState(() {
        _due = due;
        _queue = queue;
        _loading = false;
      });
    }
  }

  Future<void> _callContact(Contact contact) async {
    await startOutboundCall(widget.repository, contact);
    await _load();
  }

  Future<void> _openContact(Contact contact) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ContactDetailScreen(
          repository: widget.repository,
          contactId: contact.id!,
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateLabel = DateFormat.yMMMEd().format(DateTime.now());

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appomatrix',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Follow up today', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(dateLabel, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  if (!_loading)
                    AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _due.isEmpty
                                  ? 'Your queue is clear for now.'
                                  : '${_due.length} ${_due.length == 1 ? 'person needs' : 'people need'} your attention.',
                              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_due.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.spa_outlined,
                title: 'Nothing due right now',
                message:
                    'Add contacts and set follow-up dates, or mark someone as Follow-up.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final contact = _due[index];
                    final subtitle = contact.followUpAt != null
                        ? DateFormat.yMMMd().add_jm().format(contact.followUpAt!)
                        : contact.pipeline.label;
                    return ContactTile(
                      contact: contact,
                      subtitle: subtitle,
                      onTap: () => _openContact(contact),
                      onCallTap: () => _callContact(contact),
                    );
                  },
                  childCount: _due.length,
                ),
              ),
            ),
          if (!_loading && _queue.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: SectionHeader(
                  title: 'Call queue',
                  subtitle: 'Work top-down like a mini dialer list',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final contact = _queue[index];
                    return ContactTile(
                      contact: contact,
                      subtitle: contact.phone,
                      onTap: () => _openContact(contact),
                      onCallTap: () => _callContact(contact),
                    );
                  },
                  childCount: _queue.length,
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
