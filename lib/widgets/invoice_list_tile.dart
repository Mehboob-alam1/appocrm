import 'package:appocrm/models/invoice.dart';
import 'package:appocrm/models/invoice_status.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:appocrm/utils/invoice_format.dart';
import 'package:appocrm/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceListTile extends StatelessWidget {
  const InvoiceListTile({
    super.key,
    required this.invoice,
    required this.onTap,
  });

  final Invoice invoice;
  final VoidCallback onTap;

  Color _statusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return const Color(0xFF2F7A3E);
      case InvoiceStatus.sent:
        return AppColors.primary;
      case InvoiceStatus.cancelled:
        return AppColors.textSecondary;
      case InvoiceStatus.draft:
        return const Color(0xFFC45C26);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(invoice.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${invoice.invoiceNumber} · ${DateFormat.yMMMd().format(invoice.createdAt)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMoney(invoice.amount, invoice.currency),
                  style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    invoice.status.label,
                    style: theme.textTheme.labelLarge?.copyWith(color: color, fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
