import 'package:appocrm/app.dart';
import 'package:appocrm/data/app_database.dart';
import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/services/follow_up_notifications.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;

  final notifications = FollowUpNotificationService.instance;
  await notifications.init();

  final repository = CrmRepository(notifications: notifications);
  await notifications.syncAll(repository);

  runApp(AppomatrixApp(repository: repository));
}
