import 'package:flutter/material.dart';

import '../../utils/sentry_colors.dart';
import 'bordered_circle_avatar_view_model.dart';

class BorderedCircleAvatar extends StatelessWidget {
  BorderedCircleAvatar({
    required this.radius,
    required this.border,
    required this.viewModel,
  });

  final double radius;
  final double border;
  final BorderedCircleAvatarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(border),
        decoration: BoxDecoration(
          color: SentryColors.whisper, // border color
          shape: BoxShape.circle,
        ),
        child: viewModel.url != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(viewModel.url!),
                radius: radius,
              )
            : viewModel.initials != null
                ? CircleAvatar(
                    child: Text(viewModel.initials!,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: radius, color: Colors.white)),
                    backgroundColor: viewModel.backgroundColor,
                    radius: radius,
                  )
                : null);
  }
}
