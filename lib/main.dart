import 'package:appocrm/app.dart';
import 'package:appocrm/data/app_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;
  runApp(AppomatrixApp());
}
