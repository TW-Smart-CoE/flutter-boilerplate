import 'package:first_demo/pages/moments/tweet/controller.dart';
import 'package:flutter/material.dart';

class TweetView extends StatelessWidget {
  final TweetController _controller;

  TweetView({TweetController? tweetController, Key? key})
      : _controller = tweetController ?? TweetController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.data;
    return Container();
  }
}
