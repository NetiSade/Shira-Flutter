import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'providers/artists_provider.dart';
import 'providers/artworks_provider.dart';
import 'pages/artwork_detail_page.dart';
import 'pages/artworks_page.dart';
import 'pages/artists_page.dart';
import 'pages/artist_detail_page.dart';

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
