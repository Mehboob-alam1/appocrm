import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/models/invoice.dart';
import 'package:appocrm/models/invoice_status.dart';
import 'package:flutter/material.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({
    super.key,
    required this.repository,
    required this.contactId,
    required this.contactName,
  });

  final CrmRepository repository;
  final int contactId;
  final String contactName;

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _dueAt;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueAt = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final amount = double.tryParse(_amountController.text.trim()) ?? 0;
      final number = await widget.repository.nextInvoiceNumber(widget.contactId);
      final invoice = Invoice(
        contactId: widget.contactId,
        invoiceNumber: number,
        title: _titleController.text.trim(),
        amount: amount,
        status: InvoiceStatus.draft,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: DateTime.now(),
        dueAt: _dueAt,
      );
      await widget.repository.insertInvoice(invoice);
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New invoice')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'For ${widget.contactName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'What was the job?',
                hintText: 'AC service, tuition fee, etc.',
                prefixIcon: Icon(Icons.receipt_long_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Description is required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (INR)',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Amount is required';
                if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _pickDueDate,
              icon: const Icon(Icons.event_outlined),
              label: Text(
                _dueAt == null
                    ? 'Set due date (optional)'
                    : 'Due: ${_dueAt!.toLocal().toString().split(' ').first}',
              ),
            ),
            if (_dueAt != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _dueAt = null),
                  child: const Text('Clear due date'),
                ),
              ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save invoice'),
            ),
          ],
        ),
      ),
    );
  }
}
