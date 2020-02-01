import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shira/services/db_service.dart';
import 'package:workmanager/workmanager.dart';

import 'helpers/local_notifications_helper.dart';
import 'locator.dart';
import 'providers/artists_provider.dart';
import 'providers/artworks_provider.dart';
import 'pages/artwork_detail_page.dart';
import 'pages/artworks_page.dart';
import 'pages/artists_page.dart';
import 'pages/artist_detail_page.dart';

Future<void> main() async {
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();

  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);

  // Workmanager.registerPeriodicTask(
  //   "1",
  //   "dailyNotificationTask",
  //   frequency: Duration(minutes: 15),
  //   //initialDelay: Duration(seconds: 10),
  //   constraints: Constraints(networkType: NetworkType.connected),
  //   backoffPolicy: BackoffPolicy.linear,
  //   backoffPolicyDelay: Duration(hours: 1),
  // );

  // One off task registration
  Workmanager.registerOneOffTask(
    "1",
    "dailyNotificationTask",
    initialDelay: Duration(seconds: 10),
    constraints: Constraints(networkType: NetworkType.connected),
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: Duration(hours: 1),
  );

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
    didReceiveLocalNotificationSubject.add(ReceivedNotification(
        id: id, title: title, body: body, payload: payload));
  });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("he", "IL"),
        ],
        locale: Locale("he", "IL"),
        theme: ThemeData(
            fontFamily: 'Afek',
            primaryColor: Color.fromRGBO(154, 226, 197, 1),
            accentColor: Color.fromRGBO(248, 122, 100, 1)),
        home: ArtworksPage(),
        routes: {
          ArtworkDetailPage.routeName: (ctx) => ArtworkDetailPage(),
          ArtistsPage.routeName: (ctx) => ArtistsPage(),
          ArtworksPage.routeName: (ctx) => ArtworksPage(),
          ArtistDetailPage.routeName: (ctx) => ArtistDetailPage(),
        },
      ),
      providers: [
        ChangeNotifierProvider<ArtworksProvider>(
          create: (_) => ArtworksProvider(),
        ),
        ChangeNotifierProvider<ArtistsProvider>(
          create: (_) => ArtistsProvider(),
        ),
      ],
    );
  }
}

void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager.executeTask((task, inputData) {
    return Future(() async {
      var todayArtwork = await DbService.getArtworkOfTheToday();
      print('todayArtwork: ${todayArtwork?.title}');
      if (todayArtwork != null)
        showDailyArtworkBigTextNotification(
          todayArtwork.id,
          todayArtwork.title,
          todayArtwork.artistName,
          todayArtwork.getFirstBodyLines(),
        );

      return true;
    });
  });
}
