import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

late AudioPlayer player;

setVolume(double volume) async {
  await player.setVolume(volume);
}

setMaxVolume() async {
  await player.setVolume(0.7);
}

logoBannWidget(context) => Container(
    padding: const EdgeInsets.all(5),
    height: min(150, MediaQuery.of(context).size.height / 5),
    child: Row(children: [
      Expanded(child: Image.asset('images/logo_soroban.png')),
      const SizedBox(width: 1),
      Expanded(flex: 4, child: Image.asset('images/entete.png')),
      const SizedBox(width: 10),
      Expanded(child: Image.asset('images/logo_nour.png'))
    ]));
