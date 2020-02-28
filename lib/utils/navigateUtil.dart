import 'package:flutter/material.dart';

class navigate {
  void navigateToMain(BuildContext context, StatefulWidget widget) {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }

  void navigateToStateless(BuildContext context, StatelessWidget widget) {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }
}
