import 'package:home_widget/home_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:hive/hive.dart';
import '../models/gam3eya.dart';

class WidgetService {
  static const String _androidWidgetName = 'Gam3eyaWidgetProvider';

  static Future<void> updateAllWidgets() async {
    final box = Hive.box<Gam3eya>('gam3eyaBox');
    if (box.isEmpty) {
      await HomeWidget.saveWidgetData<String>('widget_title', 'لا توجد جمعيات');
      await HomeWidget.saveWidgetData<String>('widget_paid', '-');
      await HomeWidget.saveWidgetData<String>('widget_remaining', '-');
    } else {
      final g = box.getAt(0)!;
      await HomeWidget.saveWidgetData<String>('widget_title', g.name);
      await HomeWidget.saveWidgetData<String>('widget_paid', g.paidAmount.toStringAsFixed(0));
      await HomeWidget.saveWidgetData<String>('widget_remaining', g.remaining.toStringAsFixed(0));
    }
    await HomeWidget.updateWidget(androidName: _androidWidgetName);
  }

  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    tzdata.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _notif.initialize(const InitializationSettings(android: android, iOS: ios));
    await _notif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleReminder(Gam3eya g) async {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, g.installmentDay, 9, 0);
    if (next.isBefore(now)) {
      next = DateTime(now.year, now.month + 1, g.installmentDay, 9, 0);
    }
    await _notif.zonedSchedule(
      g.name.hashCode,
      'تذكير جمعية ${g.name}',
      'معاد القسط: ${g.installmentValue} ج.م',
      tz.TZDateTime.from(next, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'gam3eya_channel',
          'تذكيرات الجمعية',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }
}
