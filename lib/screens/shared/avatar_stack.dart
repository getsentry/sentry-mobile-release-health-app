import 'package:flutter/material.dart';

import 'bordered_circle_avatar.dart';

class AvatarStack extends StatelessWidget {
  AvatarStack(this.urls, this.height, this.border);

  final List<String> urls;
  final double height;
  final double border;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return Container(
        height: height,
      );
    }

    final radius = height / 2;
    final offset = height * 2 / 3;

    final children = <Widget>[];

    for (var index = 0 ; index < urls.length; index++ ) {
      final reversedIndex = (urls.length - 1) - index;

      final avatarUrl = urls[reversedIndex];
      final avatarOffset = offset * reversedIndex;

      if (avatarOffset > 0) {
        children.add(
          Positioned(
            left: avatarOffset,
            child: BorderedCircleAvatar(
              avatarRadius: radius - border,
              avatarBorder: border,
              url: avatarUrl
            )
          )
        );
      } else {
        children.add(
          BorderedCircleAvatar(
            avatarRadius: radius - border,
            avatarBorder: border,
            url: avatarUrl
          )
        );
      }
    }

    return Container(
      height: height,
      width: height + (offset * (urls.length - 1)),
      child: Stack(
        children: children,
      ),
    );
  }
}