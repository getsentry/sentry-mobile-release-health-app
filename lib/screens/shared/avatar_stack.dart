

import 'package:flutter/material.dart';

import '../../screens/shared/bordered_circle_avatar_view_model.dart';
import 'bordered_circle_avatar.dart';

class AvatarStack extends StatelessWidget {
  AvatarStack(this.viewModels, this.height, this.border);

  final List<BorderedCircleAvatarViewModel> viewModels;
  final double height;
  final double border;

  @override
  Widget build(BuildContext context) {
    if (viewModels.isEmpty) {
      return Container(
        height: height,
      );
    }

    final radius = height / 2;
    final offset = height * 2 / 3;

    final children = <Widget>[];

    for (var index = 0 ; index < viewModels.length; index++ ) {
      final reversedIndex = (viewModels.length - 1) - index;

      final avatarViewModel = viewModels[reversedIndex];
      final avatarOffset = offset * reversedIndex;

      if (avatarOffset > 0) {
        children.add(
          Positioned(
            left: avatarOffset,
            child: BorderedCircleAvatar(
              radius: radius - border,
              border: border,
              viewModel: avatarViewModel
            )
          )
        );
      } else {
        children.add(
          BorderedCircleAvatar(
            radius: radius - border,
            border: border,
            viewModel: avatarViewModel
          )
        );
      }
    }

    return Container(
      height: height,
      width: height + (offset * (viewModels.length - 1)),
      child: Stack(
        children: children,
      ),
    );
  }
}
