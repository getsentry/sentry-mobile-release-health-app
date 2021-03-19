// @dart=2.9


import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlScreen extends StatelessWidget {
  HtmlScreen(this._title, this._htmlFilePath);

  final String _title;
  final String _htmlFilePath;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        brightness: Brightness.dark,
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(_htmlFilePath),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data,
              padding: EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16
              ),
              onTapLink: (String text, String href, String title) async {
                if (await canLaunch(href)) {
                  await launch(href, forceSafariVC: false);
                } else {
                  throw 'Could not launch $href';
                }
              }
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }


}