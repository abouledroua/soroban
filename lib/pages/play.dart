// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soroban/classes/data.dart';
import 'package:soroban/classes/result.dart';
import 'package:soroban/classes/settting.dart';
import 'package:soroban/responsive_helper.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PlayWidget extends StatefulWidget {
  const PlayWidget({Key? key}) : super(key: key);

  @override
  _PlayWidgetState createState() => _PlayWidgetState();
}

class _PlayWidgetState extends State<PlayWidget> {
  int play = 0, indice = -1, result = 0;
  List<int> nombres = [];
  bool nbvisible = false,
      correct = false,
      wrong = false,
      isKeyboardShow = false;
  var txtController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FocusNode focusNodeBtn = FocusNode();
  late AudioPlayer numberPlayer, correctPlayer, errorPlayer, resultPlayer;

  audioNumber() async {
    numberPlayer = AudioPlayer();
    numberPlayer.setVolume(1);
    numberPlayer.setAsset('audios/chord.wav');
    numberPlayer.play();
  }

  audioResult() async {
    resultPlayer = AudioPlayer();
    resultPlayer.setVolume(1);
    resultPlayer.setAsset('audios/tada.wav');
    resultPlayer.play();
  }

  audioError() async {
    errorPlayer = AudioPlayer();
    errorPlayer.setVolume(1);
    errorPlayer.setAsset('audios/error.mp3');
    errorPlayer.play();
  }

  audioCorrect() async {
    correctPlayer = AudioPlayer();
    correctPlayer.setVolume(1);
    correctPlayer.setAsset('audios/correct.mp3');
    correctPlayer.play();
  }

  init(generate) {
    txtController.text = "";
    play = 1;
    correct = false;
    wrong = false;
    if (generate) {
      nombres = [];
    }
    indice = -1;
    nbvisible = false;
    playGame(generate);
  }

  @override
  initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    setVolume(0.05);
    Result.nbAll = 0;
    Result.nbCorrect = 0;
    init(true);
    super.initState();
  }

  playGame(bool generate) async {
    int nombre = 0;

    while (play == 1) {
      bool addnumber = generate && indice < Setting.nbOperations;
      setState(() {
        nbvisible = false;
      });
      if (generate && indice == -1)
        await Future.delayed(const Duration(milliseconds: 2000));

      if (addnumber) await genererNewNombre().then((value) => nombre = value);

      indice++;
      if (addnumber) nombres.add(nombre);

      audioNumber();

      setState(() {
        nbvisible = true;
      });
      await Future.delayed(Duration(milliseconds: Setting.timeShow));

      setState(() {
        nbvisible = false;
      });
      await Future.delayed(Duration(milliseconds: Setting.timeLaps));

      if (indice == Setting.nbOperations + 1) {
        audioResult();
        setState(() {
          play = 2;
        });
      }
    }
    FocusScope.of(context).requestFocus(focusNode);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Row(children: const [
                      Icon(Icons.exit_to_app_sharp, color: Colors.red),
                      Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Etes-vous sur ?'))
                    ]),
                    content: const Text("هل تريد فعلا الخروج ؟ "),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Non',
                              style: TextStyle(color: Colors.red))),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Oui',
                              style: TextStyle(color: Colors.green)))
                    ]))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    print("logoheigh=" + (MediaQuery.of(context).size.height / 10).toString());
    isKeyboardShow = MediaQuery.of(context).viewInsets.bottom != 0;
    print("width:" + MediaQuery.of(context).size.width.toString());
    return SafeArea(
        child: WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.fill)),
          child: Scaffold(
              backgroundColor: Colors.transparent, body: bodyContent())),
    ));
  }

  bodyContent() => ResponsiveWidget(
      mobile: phoneWidget(), tab: phoneWidget(), desktop: phoneWidget());

  phoneWidget() {
    return Column(children: [
      if (!isKeyboardShow) logoBannWidget(context),
      resultsPhoneWidget(),
      if (!isKeyboardShow) const Spacer(),
      Row(children: [
        const SizedBox(width: 10),
        jauge(),
        const SizedBox(width: 10),
        Expanded(child: playGround())
      ]),
      if (!isKeyboardShow) const Spacer(),
      if (!isKeyboardShow) paramPhoneWidget(),
      if (!isKeyboardShow) const SizedBox(height: 10)
    ]);
  }

  tabWidget() {
    return Column(children: [
      logoBannWidget(context),
      const SizedBox(height: 10),
      playGround(),
      const SizedBox(height: 10)
    ]);
  }

  desktopWidget() {
    return Column(children: [
      logoBannWidget(context),
      const SizedBox(height: 10),
      playGround(),
      const SizedBox(height: 10)
    ]);
  }

  jauge() {
    double score =
        Result.nbAll == 0 ? 0 : Result.nbCorrect * 100 / Result.nbAll;
    double myHeight = MediaQuery.of(context).size.height / 2;
    return Container(
        height: myHeight,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SfLinearGauge(
            minimum: 0,
            maximum: 100,
            animationDuration: 2,
            orientation: LinearGaugeOrientation.vertical,
            markerPointers: [
              LinearShapePointer(
                  value: score,
                  color: score < 40
                      ? Colors.red
                      : score < 80
                          ? Colors.amber
                          : Colors.green)
            ],
            barPointers: [
              LinearBarPointer(
                  value: score,
                  color: score < 40
                      ? Colors.red
                      : score < 80
                          ? Colors.amber
                          : Colors.green)
            ],
            ranges: score > 0
                ? null
                : const <LinearGaugeRange>[
                    LinearGaugeRange(
                      startValue: 0,
                      endValue: 40,
                      color: Colors.red,
                    ),
                    LinearGaugeRange(
                      startValue: 40,
                      endValue: 80,
                      color: Colors.amber,
                    ),
                    LinearGaugeRange(
                        startValue: 80, endValue: 100, color: Colors.green)
                  ]));
  }

  Future<int> genererNewNombre() async {
    int nb = 0, c = 0, cp = 0;
    while (cp < Setting.nbNumbers) {
      c = 0;
      while (c == 0) {
        c = Random().nextInt(20) - 10;
      }
      nb += c * pow(10, cp).toInt();
      cp++;
    }
    c = Random().nextInt(10);
    if (c < 5) {
      nb *= -1;
    }
    return nb;
  }

  playGround() {
    double myHeight = MediaQuery.of(context).size.height / 2;
    double myWidth = MediaQuery.of(context).size.width;
    double dif = myHeight - myWidth;
    double padHor = dif < 0 ? (dif - 10) / 2 * -1 : 0,
        padVer = dif > 0 ? (dif + 10) / 2 : 0;
    FocusScope.of(context).requestFocus(focusNode);
    return Stack(children: [
      Container(
          height: myHeight,
          width: myWidth,
          padding: EdgeInsets.symmetric(horizontal: padHor, vertical: padVer),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amberAccent.shade400.withOpacity(0.7),
          ),
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                      onEditingComplete: () {
                        int nb = int.parse(txtController.text);
                        int sum = 0;
                        for (int e in nombres) {
                          sum += e;
                        }
                        result = sum;
                        txtController.text = "";
                        Result.nbAll++;
                        if (nb == sum) {
                          correct = true;
                          audioCorrect();
                          print('yeeeesss');
                          Result.nbCorrect++;
                        } else {
                          wrong = true;
                          audioError();
                          print('no');
                        }
                        setState(() {
                          play = 3;
                        });
                        FocusScope.of(context).requestFocus(focusNodeBtn);
                      },
                      showCursor: play == 2,
                      readOnly: play != 2,
                      focusNode: focusNode,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 64),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: play == 2
                              ? Colors.white
                              : Colors.amberAccent.shade400.withOpacity(0)),
                      controller: txtController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number)))),
      Visibility(
          visible: nbvisible || play == 3,
          child: Container(
              height: myHeight,
              width: myWidth,
              padding:
                  EdgeInsets.symmetric(horizontal: padHor, vertical: padVer),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: FittedBox(
                  child: Text(
                      nbvisible
                          ? indice > Setting.nbOperations
                              ? "?"
                              : nombres[indice].toString()
                          : play == 3
                              ? result.toString()
                              : "",
                      style: TextStyle(
                          color: correct
                              ? Colors.green.shade700
                              : wrong
                                  ? Colors.red.shade700
                                  : Colors.black)))))
    ]);
  }

  paramPhoneWidget() => Container(
      height: min(MediaQuery.of(context).size.height / 6, 120),
      width: min(500, MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
          color: Colors.grey.shade400.withOpacity(0.3),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 15),
      padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: min(MediaQuery.of(context).size.width / 15, 40)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const FittedBox(
            child: Text('الإعدادات',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.visibility, color: Colors.orange.shade900),
            const SizedBox(height: 5),
            Text(Setting.timeShow.toString() + " مل / ثا ",
                style: TextStyle(color: Colors.orange.shade900))
          ]),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.visibility_off, color: Colors.grey.shade600),
            const SizedBox(height: 5),
            Text(Setting.timeLaps.toString() + " مل / ثا ",
                style: TextStyle(color: Colors.grey.shade600))
          ]),
          Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.numbers_outlined, color: Colors.indigo),
            const SizedBox(height: 5),
            Text(
                Setting.nbNumbers == 1
                    ? "رقم واحد"
                    : Setting.nbNumbers == 2
                        ? "رقمين"
                        : Setting.nbNumbers.toString() + " ارقام",
                style: const TextStyle(color: Colors.indigo))
          ]),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.confirmation_number, color: Colors.cyan.shade700),
            const SizedBox(height: 5),
            Text(
                Setting.nbOperations == 1
                    ? "عملية واحدة"
                    : Setting.nbOperations == 2
                        ? "عمليتين"
                        : Setting.nbOperations.toString() + " عمليات",
                style: TextStyle(color: Colors.cyan.shade700))
          ])
        ])
      ]));

  resultsPhoneWidget() => Container(
      height: min(MediaQuery.of(context).size.height / 6, 100),
      width: min(500, MediaQuery.of(context).size.width),
      margin: EdgeInsets.symmetric(
          horizontal: min(MediaQuery.of(context).size.width / 15, 10)),
      decoration: BoxDecoration(
          color: Colors.grey.shade400.withOpacity(0.3),
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: min(MediaQuery.of(context).size.width / 15, 10)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        InkWell(
            onTap: play == 1
                ? null
                : () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                            title: Row(children: const [
                              Icon(Icons.exit_to_app_sharp, color: Colors.red),
                              Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text('هل أنت متأكد'))
                            ]),
                            content: const Text("هل تريد فعلا الخروج ؟ "),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Non',
                                      style: TextStyle(color: Colors.red))),
                              TextButton(
                                  onPressed: () {
                                    setMaxVolume();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Oui',
                                      style: TextStyle(color: Colors.green)))
                            ])),
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: play == 1 ? Colors.grey : Colors.red,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: const Text("خروج",
                    style: TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold)))),
        InkWell(
            focusNode: focusNodeBtn,
            onTap: play == 1
                ? null
                : () {
                    init(play == 3);
                  },
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: play != 1 ? Colors.amber : Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Text(play != 3 ? "إعادة" : "إبدأ",
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold)))),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text("الإجابات الصحيحة",
              style: TextStyle(
                  color: Colors.green.shade700, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(Result.nbCorrect.toString(),
              key: ValueKey<String>(Result.nbCorrect.toString()),
              style: TextStyle(
                  color: Colors.green.shade700, fontWeight: FontWeight.bold))
        ]),
        Column(mainAxisSize: MainAxisSize.min, children: [
          const Text("عدد الإجابات",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(Result.nbAll.toString(),
              style: const TextStyle(color: Colors.black))
        ])
      ]));
}
