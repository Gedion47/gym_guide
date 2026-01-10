import 'package:flutter/material.dart';

class DietPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diet Plan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Text('Diet Page Content'),
      ),
    );
  }
}
