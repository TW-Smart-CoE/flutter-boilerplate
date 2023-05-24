import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_demo/pages/moments/user/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:get/get.dart';

class UserView extends StatelessWidget {
  final UserController _controller;

  const UserView(UserController userController, {Key? key})
      : _controller = userController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = _controller.data;
    final theme = Get.theme;

    return ConstraintLayout(children: [
      Container(
        color: theme.colorScheme.secondary,
        child: CachedNetworkImage(
          imageUrl: user.profileImage ?? '',
          fit: BoxFit.cover,
        ),
      ).applyConstraint(
        width: matchParent,
        height: 200,
        top: parent.top,
      ),
      Card(
        color: theme.colorScheme.primary,
        child: CachedNetworkImage(
          width: 80,
          height: 80,
          imageUrl: user.avatar ?? '',
          fit: BoxFit.cover,
        ),
      ).applyConstraint(
        id: ConstraintId('card'),
        top: parent.top,
        right: parent.right,
        margin: const EdgeInsets.only(top: 150, right: 20),
      ),
      Text(
        user.nick ?? user.username ?? '',
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.surface,
        ),
      ).applyConstraint(
        right: ConstraintId('card').left,
        bottom: ConstraintId('card').bottom,
        margin: const EdgeInsets.only(right: 10, bottom: 40),
      ),
    ]);
  }
}
