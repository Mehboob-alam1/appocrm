import 'package:appocrm/data/crm_repository.dart';
import 'package:appocrm/models/contact.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class FollowUpNotificationService {
  FollowUpNotificationService._();

  static final FollowUpNotificationService instance =
      FollowUpNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _ready = false;

  static const _channelId = 'follow_up_reminders';
  static const _channelName = 'Follow-up reminders';

  Future<void> init() async {
    if (kIsWeb) return;
    try {
      tz_data.initializeTimeZones();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        const InitializationSettings(android: android),
      );

      final androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: 'Reminds you when a customer follow-up is due',
          importance: Importance.high,
        ),
      );
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  Future<bool> requestPermission() async {
    if (!_ready) return false;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> syncAll(CrmRepository repository) async {
    if (!_ready) return;
    final contacts = await repository.getAllContacts();
    for (final contact in contacts) {
      await scheduleForContact(contact);
    }
  }

  Future<void> scheduleForContact(Contact contact) async {
    if (!_ready || contact.id == null) return;
    final id = contact.id!;
    await cancelForContact(id);

    final due = contact.followUpAt;
    if (due == null) return;

    var when = due;
    if (!when.isAfter(DateTime.now())) {
      when = DateTime.now().add(const Duration(minutes: 1));
    }

    final scheduled = tz.TZDateTime.from(when, tz.local);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Customer follow-up reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      id,
      'Follow up with ${contact.name}',
      'Tap to open Appomatrix CRM',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'contact:$id',
    );
  }

  Future<void> cancelForContact(int contactId) async {
    if (!_ready) return;
    await _plugin.cancel(contactId);
  }
}
