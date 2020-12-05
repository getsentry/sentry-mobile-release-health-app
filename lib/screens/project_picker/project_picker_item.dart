import 'package:flutter/material.dart';

import '../settings/settings_header.dart';

abstract class ProjectPickerItem {
  Widget build(BuildContext context);
}

class ProjectPickerOrganizationItem extends ProjectPickerItem {
  ProjectPickerOrganizationItem(this.title);
  String title;

  @override
  Widget build(BuildContext context) {
    return SettingsHeader(title);
  }
}

class ProjectPickerProjectItem extends ProjectPickerItem {
  ProjectPickerProjectItem(this.title);
  String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(right: 16, top: 0, left: 16, bottom: 0),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1.apply(
            color: Colors.black
        ),
      )
    );
  }
}