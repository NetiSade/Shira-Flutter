import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/artwork_page/artwork_page.dart';
import 'pages/home_page/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("he", "IL"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale("he", "IL"), // OR Locale('ar', 'AE') OR Other RTL locales,

      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Color.fromRGBO(154, 226, 197, 1)),
      home: HomePage(),
      routes: {ArtworkPage.routeName: (ctx) => ArtworkPage()},
    );
  }
}
