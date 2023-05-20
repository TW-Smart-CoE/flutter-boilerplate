// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tweet _$TweetFromJson(Map<String, dynamic> json) => Tweet(
      json['content'] as String?,
      (json['images'] as List<dynamic>?)
          ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['sender'] == null
          ? null
          : Sender.fromJson(json['sender'] as Map<String, dynamic>),
      json['comments'] == null
          ? null
          : Comment.fromJson(json['comments'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TweetToJson(Tweet instance) => <String, dynamic>{
      'content': instance.content,
      'images': instance.images,
      'sender': instance.sender,
      'comments': instance.comments,
    };
