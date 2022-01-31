import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soroban/classes/data.dart';
import 'package:soroban/pages/acceuil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
  playAudio();
  runApp(const MyApp());
}

playAudio() async {
  player = AudioPlayer();
  await player.setAsset('audios/intro.mp3');
  player.setLoopMode(LoopMode.all);
  player.play();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar", "DZ") // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      debugShowCheckedModeBanner: false,
      title: 'Soroban',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 32, 99, 162),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(borderSide: BorderSide(width: 1))),
          textTheme: const TextTheme(
              caption: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
              headline4:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
      home: const AcceuilPage(),
    );
  }
}
