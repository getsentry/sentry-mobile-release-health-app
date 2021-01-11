import 'package:flutter/material.dart';

import '../../utils/sentry_colors.dart';

class BorderedCircleAvatar extends StatelessWidget {
  BorderedCircleAvatar({@required this.avatarRadius, @required this.avatarBorder, @required this.url});

  final double avatarRadius;
  final double avatarBorder;
  final String url;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(avatarBorder),
      decoration: BoxDecoration(
        color: SentryColors.whisper, // border color
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(url),
        radius: avatarRadius,
      ),
    );
  }
}
