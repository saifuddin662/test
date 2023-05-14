
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 26,February,2023.

final flutterLocalNotificationProvider = Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});