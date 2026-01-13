import 'package:flutter/material.dart';

class Nav {
  static push(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  static pop(BuildContext context) => Navigator.pop(context);
}
