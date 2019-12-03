import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shira/locator.dart';
import 'package:shira/providers/artworks_provider.dart';
import 'pages/artwork_page/artwork_page.dart';
import 'pages/home_page/home_page.dart';

void main() {
  setupLocator();
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
          Locale("he", "IL"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale:
            Locale("he", "IL"), // OR Locale('ar', 'AE') OR Other RTL locales,

        theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Color.fromRGBO(154, 226, 197, 1)),

        home: HomePage(),
        routes: {
          ArtworkPage.routeName: (ctx) => ArtworkPage(),
        },
      ),
      providers: [
        ChangeNotifierProvider<ArtworksProvider>(
          create: (_) => ArtworksProvider(),
        )
      ],
    );
  }
}
