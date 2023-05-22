import 'package:first_demo/common/network/moments/model/tweet.dart';
import 'package:first_demo/pages/moments/tweet/controller.dart';
import 'package:first_demo/res/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TweetView extends StatelessWidget {
  final TweetController _controller;

  TweetView({TweetController? tweetController, Key? key})
      : _controller = tweetController ?? TweetController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final tweets = _controller.data;

    return ListView.separated(
      itemCount: tweets.length,
      itemBuilder: (_, index) => _tweetItem(tweets[index]),
      separatorBuilder: (_, __) => const Divider(height: 1),
    );
  }

  Widget _tweetItem(Tweet tweet) {
    final theme = Get.theme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Image.network(
            tweet.sender?.avatar ?? '',
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tweet.sender?.nick ?? tweet.sender?.username ?? '',
                style: theme.textTheme.titleLarge?.copyWith(
                    color: momentsUserNameColor, fontWeight: FontWeight.normal),
              ),
              if (tweet.content != null && tweet.content!.isNotEmpty) ...[
                Text(
                  tweet.content!,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.normal),
                )
              ],
            ],
          ),
        ),
      ]),
    );
  }
}
