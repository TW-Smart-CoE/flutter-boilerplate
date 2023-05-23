import 'package:first_demo/common/network/moments/model/comment.dart';
import 'package:first_demo/common/network/moments/model/image.dart' as model;
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

  Widget _tweetItem(Tweet tweet) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  style: _theme.textTheme.titleLarge?.copyWith(
                      color: momentsUserNameColor,
                      fontWeight: FontWeight.normal),
                ),
                if (tweet.content != null && tweet.content!.isNotEmpty) ...[
                  Text(
                    tweet.content!,
                    style: _theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.normal),
                  )
                ],
                if (tweet.images != null && tweet.images!.isNotEmpty) ...[
                  _imageGrid(tweet.images!)
                ],
                if (tweet.comments != null && tweet.comments!.isNotEmpty) ...[
                  _comments(tweet.comments!)
                ],
              ],
            ),
          ),
        ]),
      );

  Widget _imageGrid(List<model.Image> images) {
    final cnt = images.length;
    final int crossAxisCount;
    if (cnt <= 1) {
      crossAxisCount = 1;
    } else if (cnt <= 3) {
      crossAxisCount = 3;
    } else if (cnt <= 4) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    final double widthFactor;
    if (crossAxisCount == 1 || crossAxisCount == 2) {
      widthFactor = 2 / 3;
    } else {
      widthFactor = 1;
    }

    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: GridView.count(
        padding: const EdgeInsets.symmetric(vertical: 5),
        shrinkWrap: true,
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
        children: images
            .map((image) => Image.network(
                  image.url,
                  fit: BoxFit.cover,
                ))
            .toList(),
      ),
    );
  }

  Widget _comments(List<Comment> comments) => Container(
        width: double.infinity,
        decoration: ShapeDecoration(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            )),
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: comments
              .where((it) => it.content.isNotEmpty)
              .map((comment) => _commentItem(comment))
              .toList(),
        ),
      );

  Widget _commentItem(Comment comment) => Text.rich(TextSpan(
        style: _theme.textTheme.titleSmall?.copyWith(height: 1.5),
        children: [
          TextSpan(
            text: comment.sender.nick ?? comment.sender.username ?? '',
            style: const TextStyle(color: momentsUserNameColor),
          ),
          const TextSpan(text: ':'),
          const TextSpan(text: ' '),
          TextSpan(
              text: comment.content,
              style: const TextStyle(fontWeight: FontWeight.normal)),
        ],
      ));

  ThemeData get _theme => Get.theme;
}
