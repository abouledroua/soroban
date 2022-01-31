// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tab;
  final Widget desktop;

  const ResponsiveWidget(
      {Key? key,
      required this.mobile,
      required this.tab,
      required this.desktop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        print("phoneWidget");
        return mobile;
      } else if (constraints.maxWidth < 1024) {
        print("tabWidget");
        return tab;
      } else {
        print("desktopWidget");
        return desktop;
      }
    });
  }
}
