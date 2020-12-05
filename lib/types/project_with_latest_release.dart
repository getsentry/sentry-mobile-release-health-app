import 'package:sentry_mobile/types/project.dart';
import 'package:sentry_mobile/types/release.dart';

class ProjectWithLatestRelease {
  ProjectWithLatestRelease(this.project, this.release);

  final Project project;
  final Release release;
}