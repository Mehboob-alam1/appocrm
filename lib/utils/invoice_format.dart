import 'package:appocrm/models/contact.dart';
import 'package:appocrm/models/invoice.dart';
import 'package:intl/intl.dart';

String formatMoney(double amount, String currency) {
  if (currency == 'INR') {
    return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }
  return '$currency ${amount.toStringAsFixed(2)}';
}

String buildInvoiceText({
  required Invoice invoice,
  required Contact contact,
  String businessName = 'Appomatrix',
}) {
  final date = DateFormat.yMMMd().format(invoice.createdAt);
  final due = invoice.dueAt != null
      ? DateFormat.yMMMd().format(invoice.dueAt!)
      : '—';
  final buffer = StringBuffer()
    ..writeln('INVOICE')
    ..writeln('${invoice.invoiceNumber}')
    ..writeln('')
    ..writeln('From: $businessName')
    ..writeln('To: ${contact.name}')
    ..writeln('Phone: ${contact.phone}')
    ..writeln('')
    ..writeln('Date: $date')
    ..writeln('Due: $due')
    ..writeln('Status: ${invoice.status.label}')
    ..writeln('')
    ..writeln(invoice.title)
    ..writeln('Amount: ${formatMoney(invoice.amount, invoice.currency)}');
  if (invoice.notes != null && invoice.notes!.trim().isNotEmpty) {
    buffer
      ..writeln('')
      ..writeln('Notes:')
      ..writeln(invoice.notes);
  }
  buffer.writeln('\n— Sent via Appomatrix CRM');
  return buffer.toString();
}
