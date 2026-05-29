import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_demo/features/moments/user/model_user.dart';
import 'package:first_demo/res/theme/dimension.dart';
import 'package:first_demo/res/theme/shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

class UserView extends StatelessWidget {
  final User _user;

  const UserView({required User user, super.key}) : _user = user;

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final theme = Theme.of(context);

    return ConstraintLayout(children: [
      Container(
        color: theme.colorScheme.secondary,
        child: CachedNetworkImage(
          imageUrl: user.profileImage ?? '',
          fit: BoxFit.cover,
        ),
      ).applyConstraint(
        width: matchParent,
        height: WidgetSize.Giant,
        top: parent.top,
      ),
      Card(
        color: theme.colorScheme.primary,
        shape: BorderShape.S,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CachedNetworkImage(
          width: WidgetSize.XXL,
          height: WidgetSize.XXL,
          imageUrl: user.avatar ?? '',
          fit: BoxFit.cover,
        ),
      ).applyConstraint(
        id: ConstraintId('card'),
        top: parent.top,
        right: parent.right,
        margin: const EdgeInsets.only(top: 150, right: EdgeInset.S),
      ),
      Text(
        user.nick ?? user.username ?? '',
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.surface,
        ),
      ).applyConstraint(
        right: ConstraintId('card').left,
        bottom: ConstraintId('card').bottom,
        margin: const EdgeInsets.only(right: EdgeInset.XXS, bottom: EdgeInset.XL),
      ),
    ]);
  }
}
