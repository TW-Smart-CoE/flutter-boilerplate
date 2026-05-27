import 'package:first_demo/common/async_loader/async_load_processor.dart';
import 'package:first_demo/common/async_loader/auto_load_controller.dart';
import 'package:first_demo/common/scaffold/base_scaffold.dart';
import 'package:first_demo/pages/moments/controller.dart';
import 'package:first_demo/pages/moments/tweet/view.dart';
import 'package:first_demo/pages/moments/user/view.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MomentsPage extends StatelessWidget {
  final MomentsController _controller;

  MomentsPage({MomentsController? momentsController, Key? key})
      : _controller = momentsController ?? Get.put(MomentsController()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      context: context,
      title: l10n(context).momentsPageTitle,
      body: AsyncLoadProcessor(
        context,
        Get.put(AutoLoadController(_controller)),
        content: (data) => NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: UserView(_controller.userController),
            ),
          ],
          body: TweetView(_controller.tweetController),
        ),
      ),
    );
  }
}
