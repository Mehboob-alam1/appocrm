import 'package:url_launcher/url_launcher.dart';

String normalizePhoneForDial(String phone) {
  return phone.replaceAll(RegExp(r'[^\d+]'), '');
}

Future<bool> launchPhoneCall(String phone) async {
  final uri = Uri(scheme: 'tel', path: normalizePhoneForDial(phone));
  return launchUrl(uri);
}

Future<bool> launchWhatsAppChat(String phone, {String? message}) async {
  var digits = normalizePhoneForDial(phone);
  if (digits.startsWith('+')) {
    digits = digits.substring(1);
  }
  final query = message != null && message.isNotEmpty
      ? '?text=${Uri.encodeComponent(message)}'
      : '';
  final uri = Uri.parse('https://wa.me/$digits$query');
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
