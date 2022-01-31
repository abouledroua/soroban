// ignore_for_file: avoid_print

import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soroban/classes/data.dart';
import 'package:soroban/classes/settting.dart';
import 'package:soroban/pages/play.dart';
import 'package:soroban/responsive_helper.dart';

class AcceuilPage extends StatefulWidget {
  const AcceuilPage({Key? key}) : super(key: key);

  @override
  _AcceuilPageState createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  late double value;
  bool isKeyboardShow = false;
  var txtController = TextEditingController();

  getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    Setting.timeShow = prefs.getInt('timeShow') ?? 0;
    if (Setting.timeShow == 0) {
      Setting.timeShow = 800;
      prefs.setInt('timeShow', Setting.timeShow);
    }
    Setting.timeLaps = prefs.getInt('timeLaps') ?? 0;
    if (Setting.timeLaps == 0) {
      Setting.timeLaps = 700;
      prefs.setInt('timeLaps', Setting.timeLaps);
    }
    Setting.nbNumbers = prefs.getInt('nbNumbers') ?? 0;
    if (Setting.nbNumbers == 0) {
      Setting.nbNumbers = 1;
      prefs.setInt('nbNumbers', Setting.nbNumbers);
    }
    Setting.nbOperations = prefs.getInt('nbOperations') ?? 0;
    if (Setting.nbOperations == 0) {
      Setting.nbOperations = 3;
      prefs.setInt('nbOperations', Setting.nbOperations);
    }
    setState(() {});
  }

  @override
  initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    setMaxVolume();
    getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isKeyboardShow = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.fill)),
            child: Scaffold(
                backgroundColor: Colors.transparent, body: bodyContent())));
  }

  bodyContent() => ResponsiveWidget(
      mobile: phoneWidget(), tab: phoneWidget(), desktop: phoneWidget());

  phoneWidget() => Column(children: [
        if (!isKeyboardShow) logoBannWidget(context),
        if (!isKeyboardShow) const SizedBox(height: 10),
        if (!isKeyboardShow) sorobanBannWidget(),
        if (!isKeyboardShow) const Spacer(),
        if (!isKeyboardShow) paramWidget(),
        if (!isKeyboardShow) const Spacer(),
        startButtonWidget(),
        if (!isKeyboardShow)
          SizedBox(height: MediaQuery.of(context).size.height / 20)
      ]);

  sorobanBannWidget() => SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7,
      child: FittedBox(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: min(MediaQuery.of(context).size.width / 40, 8)),
        child: AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText('السوروبان العربي',
                  textStyle: const TextStyle(
                      fontSize: 32.0, fontWeight: FontWeight.bold))
            ],
            repeatForever: true,
            pause: const Duration(milliseconds: 350),
            displayFullTextOnTap: true),
      )));

  majParams(int type, int ivalue) {
    switch (type) {
      case 1:
        Setting.timeShow = ivalue;
        break;
      case 2:
        Setting.timeLaps = ivalue;
        break;
      case 3:
        Setting.nbNumbers = ivalue;
        break;
      case 4:
        Setting.nbOperations = ivalue;
        break;
      default:
    }
  }

  showModal(int type) {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  late String title, subTitle;
                  late double min, max;
                  late int division;
                  int ivalue = value.round();
                  switch (type) {
                    case 1:
                      min = 100;
                      max = 2000;
                      division = 20;
                      subTitle = "وقت ظهور الآرقام ";
                      title = " وقت ظهور الآرقام : $ivalue مل / ثا";
                      break;
                    case 2:
                      min = 10;
                      max = 10010;
                      division = 250;
                      subTitle = "وقت إخفاء الآرقام ";
                      title = " وقت إخفاء الآرقام : $ivalue مل / ثا";
                      break;
                    case 3:
                      min = 1;
                      max = 4;
                      division = 3;
                      subTitle = "عدد الأرقام ";
                      title = " عدد الأرقام : ";
                      switch (ivalue) {
                        case 1:
                          title += "رقم واحد";
                          break;
                        case 2:
                          title += "رقمين";
                          break;
                        default:
                          title += "$ivalue أرقام";
                          break;
                      }
                      break;
                    case 4:
                      min = 1;
                      max = 10;
                      division = 9;
                      subTitle = "عدد العمليات ";
                      title = " عدد العمليات : $ivalue عملية";
                      title = " عدد العمليات : ";
                      switch (ivalue) {
                        case 1:
                          title += "عملية واحدة";
                          break;
                        case 2:
                          title += "عمليتين";
                          break;
                        default:
                          title += "$ivalue عمليات";
                          break;
                      }
                      break;
                    default:
                  }
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(title,
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold))),
                            Row(children: [
                              Expanded(
                                  child: Slider.adaptive(
                                      activeColor: type < 3
                                          ? value < max / 4
                                              ? Colors.red
                                              : value < max * 2 / 3
                                                  ? Colors.amber
                                                  : Colors.green
                                          : value < max / 3
                                              ? Colors.green
                                              : value < max * 3 / 4
                                                  ? Colors.amber
                                                  : Colors.red,
                                      onChanged: (newValue) {
                                        ivalue = newValue.round();
                                        majParams(type, ivalue);
                                        setState(() {
                                          value = newValue;
                                        });
                                      },
                                      min: min,
                                      divisions: division,
                                      max: max,
                                      label: "$value",
                                      value: value)),
                              const SizedBox(width: 10),
                              InkWell(
                                  onTap: () {
                                    txtController.text = ivalue.toString();
                                    editValue(subTitle, min, max, ivalue, type);
                                  },
                                  child: const Icon(Icons.edit))
                            ])
                          ]));
                });
              });
        }).then((value) {
      setState(() {});
    });
  }

  paramWidget() => Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade400.withOpacity(0.3),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.height / 20))),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 15),
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: MediaQuery.of(context).size.width / 15),
      width: MediaQuery.of(context).size.width,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText('الإعدادات',
                  textStyle: const TextStyle(
                      fontSize: 32.0, fontWeight: FontWeight.bold),
                  speed: const Duration(milliseconds: 200))
            ],
            repeatForever: true,
            pause: const Duration(milliseconds: 350),
            displayFullTextOnTap: true),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
              onTap: () {
                print("edit time show");
                value = Setting.timeShow.toDouble();
                showModal(1);
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.visibility, color: Colors.orange.shade900),
                const SizedBox(height: 5),
                Text(Setting.timeShow.toString() + " مل / ثا ",
                    style: TextStyle(color: Colors.orange.shade900))
              ])),
          InkWell(
              onTap: () {
                print("edit time off");
                value = Setting.timeLaps.toDouble();
                showModal(2);
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.visibility_off, color: Colors.grey.shade600),
                const SizedBox(height: 5),
                Text(Setting.timeLaps.toString() + " مل / ثا ",
                    style: TextStyle(color: Colors.grey.shade600))
              ])),
          InkWell(
              onTap: () {
                print("edit numberr of numbers");
                value = Setting.nbNumbers.toDouble();
                showModal(3);
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.numbers_outlined, color: Colors.indigo),
                const SizedBox(height: 5),
                Text(
                    Setting.nbNumbers == 1
                        ? "رقم واحد"
                        : Setting.nbNumbers == 2
                            ? "رقمين"
                            : Setting.nbNumbers.toString() + " ارقام",
                    style: const TextStyle(color: Colors.indigo))
              ])),
          InkWell(
              onTap: () {
                print("edit number of operations");
                value = Setting.nbOperations.toDouble();
                showModal(4);
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.confirmation_number, color: Colors.cyan.shade700),
                const SizedBox(height: 5),
                Text(
                    Setting.nbOperations == 1
                        ? "عملية واحدة"
                        : Setting.nbOperations == 2
                            ? "عمليتين"
                            : Setting.nbOperations.toString() + " عمليات",
                    style: TextStyle(color: Colors.cyan.shade700))
              ]))
        ])
      ]));

  startButtonWidget() => InkWell(
        onTap: () async {
          var route =
              MaterialPageRoute(builder: (context) => const PlayWidget());
          Navigator.of(context).push(route);
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(
                    Radius.circular(MediaQuery.of(context).size.height / 20))),
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 30),
            width: MediaQuery.of(context).size.width * 4 / 9,
            height: MediaQuery.of(context).size.height / 5,
            child: const FittedBox(child: InkWell(child: Text("إبدأ")))),
      );

  editValue(subTitle, min, max, ivalue, type) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: Text(subTitle),
              content: TextField(
                  controller: txtController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  maxLines: 1),
              actions: [
                InkWell(
                    onTap: () {
                      double newValue = double.parse(txtController.text);
                      if (newValue < min || newValue > max) {
                        txtController.clear();
                      } else {
                        setState(() {
                          value = double.parse(txtController.text);
                          ivalue = value.round();
                          majParams(type, ivalue);
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.green,
                        child: const Icon(Icons.check, color: Colors.white)))
              ]);
        }).then((value) => setState(() {}));
  }
}
