import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/enum/platform_type.dart';
import '../../flavor/flavor_provider.dart';
import 'firebase_background_messaging.dart';
import 'firebase_messaging_provider.dart';
import 'local_push_notification.dart';
import 'model/received_notification.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 26,February,2023.

final firebasePushNotificationProvider =
    Provider<FirebasePushNotification>((ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  final localPushNotification = ref.watch(localPushNotificationProvider);

  return FirebasePushNotification(messaging, localPushNotification, ref);
});

class FirebasePushNotification {
  final FirebaseMessaging _messaging;
  final LocalPushNotification _localPushNotification;
  final Ref _ref;

  FirebasePushNotification(
      this._messaging, this._localPushNotification, this._ref) {
    _init();
    _onFirebaseMessageReceived();
    _setupInteractedMessage();
  }

  void _init() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    subscribeTopic('MAIN', PlatformType.ALL);
    subscribeTopic('MAIN', PlatformType.IOS);
    subscribeTopic('MAIN', PlatformType.ANDROID);
    if (kDebugMode) subscribeTopic('SHAJ', PlatformType.ALL);
  }

  void subscribeTopic(String topic, PlatformType targetPlatform) {
    final userType = _ref.read(flavorProvider).name;
    var platformTopic = topic;

    if (targetPlatform == PlatformType.ALL) {
      platformTopic = 'ALL_${userType}_$topic';
      setTopic(platformTopic);
    } else if (targetPlatform == PlatformType.IOS && Platform.isIOS) {
      platformTopic = 'IOS_${userType}_$topic';
      setTopic(platformTopic);
    } else if (targetPlatform == PlatformType.ANDROID && Platform.isAndroid) {
      platformTopic = 'ANDROID_${userType}_$topic';
      setTopic(platformTopic);
    }
  }

  void setTopic(String platformTopic) {
    if (kDebugMode) {
      final testTopic = 'TEST_$platformTopic';
      FirebaseMessaging.instance.subscribeToTopic(testTopic);
      debugPrint(
          '=============> Notification TOPIC : $testTopic <=============');
    } else {
      final prodTopic = 'PROD_$platformTopic';
      FirebaseMessaging.instance.subscribeToTopic(prodTopic);
      debugPrint(
          '=============> Notification TOPIC : $prodTopic <=============');
    }
  }

  void _onFirebaseMessageReceived() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> data = message.data;
      String? imgUrl = '';

      if (notification != null && android != null) {
        if (android.imageUrl != null) {
          imgUrl = android.imageUrl ?? "";
        }else if(data.keys.contains('imageUrl'))
        {
          imgUrl = data['imageUrl'];
        }

        _localPushNotification.showNotification(
          ReceivedNotification(
            notification.hashCode,
            notification.title,
            notification.body,
            imgUrl,
            jsonEncode(data),
          ),
        );
      }
    });
  }

  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['link'] != null) {
      final String link = message.data['link'];

      // todo shaj handle nav
      //_ref.read().go();
    }
  }

  Future<String?> getFirebaseToken() async {
    return await _messaging.getToken();
  }

  Future<String?> getAPNSToken() async {
    return await _messaging.getAPNSToken();
  }

  Future<NotificationSettings> getNotificationSettings() async {
    return await _messaging.getNotificationSettings();
  }
}
