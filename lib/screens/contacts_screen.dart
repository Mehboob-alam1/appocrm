import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/models/contact.dart';
import 'package:appocrm/screens/add_contact_screen.dart';
import 'package:appocrm/screens/contact_detail_screen.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:appocrm/widgets/app_card.dart';
import 'package:appocrm/widgets/contact_tile.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key, required this.repository});

  final CrmRepository repository;

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await widget.repository.getAllContacts();
    if (mounted) {
      setState(() {
        _contacts = list;
        _loading = false;
      });
    }
  }

  List<Contact> get _filtered {
    if (_query.trim().isEmpty) return _contacts;
    final q = _query.toLowerCase();
    return _contacts
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.phone.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<void> _addContact() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => AddContactScreen(repository: widget.repository),
      ),
    );
    if (added == true) await _load();
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

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contacts', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${_contacts.length} saved on this phone',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: 'Search name or phone',
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          onPressed: () => setState(() => _query = ''),
                          icon: const Icon(Icons.close_rounded),
                        )
                      : null,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? Center(
                          child: EmptyState(
                            icon: Icons.person_search_outlined,
                            title: _contacts.isEmpty ? 'No contacts yet' : 'No matches',
                            message: _contacts.isEmpty
                                ? 'Tap Add to create your first customer.'
                                : 'Try a different name or phone number.',
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                            itemCount: _filtered.length,
                            itemBuilder: (context, index) {
                              final contact = _filtered[index];
                              return ContactTile(
                                contact: contact,
                                subtitle: '${contact.phone} · ${contact.pipeline.label}',
                                onTap: () => _openContact(contact),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: _addContact,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add'),
          ),
        ),
      ],
    );
  }
}
