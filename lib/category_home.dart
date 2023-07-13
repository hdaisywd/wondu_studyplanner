import 'package:flutter/material.dart';

class CategoryHome extends StatelessWidget {
  const CategoryHome({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(159, 255, 158, 190),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: null,
    );
  }
}
