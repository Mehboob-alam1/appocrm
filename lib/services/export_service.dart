import 'dart:io';

import 'package:appocrm/data/crm_repository.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  ExportService(this._repository);

  final CrmRepository _repository;

  Future<void> shareContactsCsv() async {
    final contacts = await _repository.getAllContacts();
    final buffer = StringBuffer()
      ..writeln('name,phone,pipeline,follow_up_at,notes_preview');

    for (final contact in contacts) {
      if (contact.id == null) continue;
      final notes = await _repository.getNotesForContact(contact.id!);
      final preview = notes.isNotEmpty
          ? notes.first.body.replaceAll('\n', ' ').replaceAll(',', ';')
          : '';
      final followUp =
          contact.followUpAt?.toIso8601String() ?? '';
      buffer.writeln(
        '"${_escape(contact.name)}","${_escape(contact.phone)}",'
        '"${contact.pipeline.label}","$followUp","${_escape(preview)}"',
      );
    }

    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final file = File('${dir.path}/appomatrix_export_$stamp.csv');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Appomatrix CRM export',
      text: 'Customer export from Appomatrix CRM (local backup).',
    );
  }

  String _escape(String value) => value.replaceAll('"', '""');
}
