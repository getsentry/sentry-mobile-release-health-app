import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  SettingsHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFFB9C1D9),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
