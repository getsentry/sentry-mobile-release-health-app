import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sentry_mobile/utils/platform_icons.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

class PlatformImage extends StatelessWidget {

  PlatformImage(this.platform, this.border);
  final String? platform;
  final double border;

  @override
  Widget build(BuildContext context) {
    const width = 22.0;
    const height = 22.0;
    Widget? platformImage;
    final platform = this.platform;
    if (platform != null) {
      platformImage = PlatformIcons.svgPicture(platform, width, height);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(border),
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          child: Container(
            width: width,
            height: height,
            color: SentryColors.snuff,
            child: platformImage ?? Container(
              width: width,
              height: height,
            ),
          ),
        ),
      ),
    );
  }
}
