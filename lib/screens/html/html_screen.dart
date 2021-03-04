
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart' show rootBundle;
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
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(_htmlFilePath),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Html(
                data: snapshot.data,
                padding: EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16
                ),
                onLinkTap: (String link) async {
                  if (await canLaunch(link)) {
                    await launch(link, forceSafariVC: false);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
              ),
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