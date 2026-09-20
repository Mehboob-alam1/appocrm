import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/screens/main_shell.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppomatrixApp extends StatelessWidget {
  AppomatrixApp({super.key, CrmRepository? repository})
      : repository = repository ?? CrmRepository();

  final CrmRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appomatrix CRM',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: MainShell(repository: repository),
    );
  }
}
