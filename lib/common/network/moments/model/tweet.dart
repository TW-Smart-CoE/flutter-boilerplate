import 'package:first_demo/common/network/moments/model/comment.dart';
import 'package:first_demo/common/network/moments/model/image.dart';
import 'package:first_demo/common/network/moments/model/sender.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tweet.g.dart';

@JsonSerializable()
class Tweet {
  final String? content;
  final List<Image>? images;
  final Sender? sender;
  final Comment? comments;

  const Tweet(this.content, this.images, this.sender, this.comments);

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);

  Map<String, dynamic> toJson() => _$TweetToJson(this);
}
