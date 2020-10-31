import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: _content(),
    );
  }

  Widget _content() {
    return Container(
        margin: EdgeInsets.all(22.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    'Working Code, Happy Customers',
                    style: Theme.of(context).textTheme.headline1
                ),
                if (!_loading)
                  RaisedButton(
                    child: Text('SignIn'),
                    textColor: Colors.white,
                    color: Color(0xff4e3fb4),
                    onPressed: () {
                      setState(() {
                        _loading = !_loading;
                      });
                    },
                  )
                else
                  CircularProgressIndicator(
                    backgroundColor: Color(0xff4e3fb4),
                  )
              ],
            )
        )
    );
  }
}