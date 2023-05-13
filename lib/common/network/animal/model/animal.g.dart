// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Animal _$AnimalFromJson(Map<String, dynamic> json) => Animal(
      breeds: json['breeds'] as List<dynamic>?,
      id: json['id'] as String?,
      url: json['url'] as String?,
      width: json['width'],
      height: json['height'],
    );

Map<String, dynamic> _$AnimalToJson(Animal instance) => <String, dynamic>{
      'breeds': instance.breeds,
      'id': instance.id,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
