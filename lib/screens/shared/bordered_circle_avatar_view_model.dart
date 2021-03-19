// @dart=2.9

import 'package:flutter/material.dart';

import '../../types/author.dart';
import '../../utils/letter_avatar.dart';

class BorderedCircleAvatarViewModel {
  BorderedCircleAvatarViewModel(this.url, this.initials, this.backgroundColor);
  factory BorderedCircleAvatarViewModel.from(Author author) {

    if (author.avatar?.avatarType == 'letter_avatar') {
      return BorderedCircleAvatarViewModel(
          null,
          LetterAvatar.getInitials(author.name ?? author.email),
          LetterAvatar.getLetterAvatarColor('${author.id}-${author.email}')
      );
    } else {
      return BorderedCircleAvatarViewModel(
          author.avatarUrl,
          null,
          null
      );
    }
  }

  final String url;
  final String initials;
  final Color backgroundColor;
}
