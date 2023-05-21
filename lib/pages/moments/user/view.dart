import 'package:first_demo/pages/moments/user/controller.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  final UserController _controller;

  UserView({UserController? userController, Key? key})
      : _controller = userController ?? UserController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.data;
    return Container();
  }
}
