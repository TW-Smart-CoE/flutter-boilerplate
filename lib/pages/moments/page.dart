import 'package:first_demo/common/async_loader/async_load_processor.dart';
import 'package:first_demo/common/async_loader/auto_load_controller.dart';
import 'package:first_demo/common/scaffold/base_scaffold.dart';
import 'package:first_demo/pages/moments/controller.dart';
import 'package:first_demo/pages/moments/tweet/view.dart';
import 'package:first_demo/pages/moments/user/view.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';

class MomentsPage extends StatelessWidget {
  final MomentsController _controller;

  MomentsPage({MomentsController? momentsController, Key? key})
      : _controller = momentsController ?? MomentsController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: stringRes(R.moments_page_title),
      body: AsyncLoadProcessor(
        AutoLoadController(_controller),
        content: (data) => Column(
          children: [
            UserView(userController: _controller.userController),
            TweetView(tweetController: _controller.tweetController),
          ],
        ),
      ),
    );
  }
}
