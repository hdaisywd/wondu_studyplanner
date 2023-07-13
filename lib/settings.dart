import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/wondu_appbar_image.png',
          width: 150,
        ),
        backgroundColor: Color.fromARGB(159, 255, 158, 190),
        centerTitle: true,
      ),
    );
  }
}
