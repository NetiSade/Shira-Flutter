import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

//TODO: move all into a class with ststic methods

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

Future<void> showDailyArtworkNotification(
  String artworkId,
  String artworkTitle,
  String artworkArtistName,
) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '0',
    'Daily',
    'Shira Daily',
    importance: Importance.Default,
    priority: Priority.Default,
    ticker: '',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    artworkTitle,
    artworkArtistName,
    platformChannelSpecifics,
    payload: artworkId,
  );
}

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancel(0);
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> showDailyArtworkBigTextNotification(
  String artworkId,
  String artworkTitle,
  String artworkArtistName,
  String artworkBody,
) async {
  var bigTextStyleInformation = BigTextStyleInformation('$artworkBody',
      htmlFormatBigText: false,
      contentTitle: '<b>$artworkTitle / $artworkArtistName</b>',
      htmlFormatContentTitle: true,
      summaryText: '$artworkTitle / $artworkArtistName',
      htmlFormatSummaryText: false);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '0',
    'Daily',
    'Shira Daily',
    style: AndroidNotificationStyle.BigText,
    styleInformation: bigTextStyleInformation,
  );
  var platformChannelSpecifics =
      NotificationDetails(androidPlatformChannelSpecifics, null);
  await flutterLocalNotificationsPlugin.show(
    0,
    artworkTitle,
    artworkArtistName,
    platformChannelSpecifics,
    payload: artworkId,
  );
}

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}
