  import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  import 'package:permission_handler/permission_handler.dart';

  class NotificationHelper {
    static final NotificationHelper _instance = NotificationHelper._internal();
    factory NotificationHelper() => _instance;
    NotificationHelper._internal();

    final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();
    int _notificationId = 0;
    Future<void> initialize() async {
      // 1. 创建通道（参数不变）
      const channel = AndroidNotificationChannel(
        'high_importance_channel_1',
        '新消息通知',
        description: '常规通知',
        importance: Importance.max,
      );
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 2. 初始化插件（参数不变）
      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
      );
      await _notificationsPlugin.initialize(initSettings);
    }

    Future<void> showNotification({
      required String title,
      required String body,
    }) async {
      await Permission.notification.request();
      bool hasPermission = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ?? false;

      if (hasPermission) {
        const androidDetails = AndroidNotificationDetails(
          'high_importance_channel_1',
          '新消息通知',
          channelDescription: '常规通知',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          autoCancel: true,
          icon: '@drawable/ic_notification',
          fullScreenIntent: true,
          visibility: NotificationVisibility.public, // 锁屏也能弹
          enableLights: true,
        );

        await _notificationsPlugin.show(
          _notificationId++,
          title,
          body,
          NotificationDetails(android: androidDetails),
        );
      }
    }
  }
