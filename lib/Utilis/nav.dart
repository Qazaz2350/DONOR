import 'package:flutter/material.dart';

class Nav {
  // Push a new page on top of the stack
  static push(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  // Push a new page and remove the previous page (replacement)
  static pushReplacement(BuildContext context, Widget page) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );

  // Pop the current page
  static pop(BuildContext context) => Navigator.pop(context);
}
