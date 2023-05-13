import 'package:json_annotation/json_annotation.dart';

part 'animal.g.dart';

@JsonSerializable()
class Animal {
  final List<dynamic>? breeds;
  final String? id;
  final String? url;
  final dynamic width;
  final dynamic height;

  const Animal({
    this.breeds,
    this.id,
    this.url,
    this.width,
    this.height,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalToJson(this);
}
