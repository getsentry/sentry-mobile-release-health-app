// @dart=2.9

import 'project.dart';
import 'release.dart';

class ProjectWithLatestRelease {
  ProjectWithLatestRelease(this.project, this.release);

  final Project project;
  final Release release;
}