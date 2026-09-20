import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/models/contact.dart';
import 'package:appocrm/models/invoice.dart';
import 'package:appocrm/models/invoice_status.dart';
import 'package:appocrm/utils/invoice_format.dart';
import 'package:appocrm/utils/launchers.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showInvoiceDetailSheet({
  required BuildContext context,
  required CrmRepository repository,
  required Contact contact,
  required Invoice invoice,
  required VoidCallback onChanged,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(invoice.invoiceNumber, style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                formatMoney(invoice.amount, invoice.currency),
                style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(invoice.title, style: Theme.of(ctx).textTheme.bodyLarge),
              if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(invoice.notes!, style: Theme.of(ctx).textTheme.bodyMedium),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () async {
                  final text = buildInvoiceText(invoice: invoice, contact: contact);
                  await Share.share(text, subject: 'Invoice ${invoice.invoiceNumber}');
                  if (invoice.status == InvoiceStatus.draft && invoice.id != null) {
                    await repository.updateInvoice(
                      invoice.copyWith(status: InvoiceStatus.sent),
                    );
                    onChanged();
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share invoice'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final text = buildInvoiceText(invoice: invoice, contact: contact);
                  await launchWhatsAppChat(contact.phone, message: text);
                  if (invoice.status == InvoiceStatus.draft && invoice.id != null) {
                    await repository.updateInvoice(
                      invoice.copyWith(status: InvoiceStatus.sent),
                    );
                    onChanged();
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                icon: const Icon(Icons.chat_outlined),
                label: const Text('Send via WhatsApp'),
              ),
              if (invoice.status != InvoiceStatus.paid && invoice.id != null) ...[
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    await repository.markInvoicePaid(
                      invoice.id!,
                      contactId: contact.id!,
                    );
                    onChanged();
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Mark as paid'),
                ),
              ],
              if (invoice.id != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: ctx,
                      builder: (d) => AlertDialog(
                        title: const Text('Delete invoice?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(d, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(d, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await repository.deleteInvoice(invoice.id!);
                      onChanged();
                      if (ctx.mounted) Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Delete invoice'),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
