import 'dart:io';

class LoginAction {
  LoginAction(this.payload);
  final Cookie payload;
}

class TitleAction {
  TitleAction(this.payload);
  final String payload;
}