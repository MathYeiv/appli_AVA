import 'package:flutter/material.dart';
import '../../global_files.dart';

Widget noItemsWidget(IconData icon, String item) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon, size: 20),
      SizedBox(
        height: getScreenHeight() * 0.015,
      ),
      Text('No $item found')
    ],
  );
}