import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable()
class Resource {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "ext")
  final String ext;
  @JsonKey(name: "pin")
  final String? pin;
  @JsonKey(name: "path")
  final String path;
  @JsonKey(name: "level")
  final int level;
  @JsonKey(name: "parent_id")
  final String? parentId;
  @JsonKey(name: "size")
  final int size;
  @JsonKey(name: "created_at")
  final String createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  Resource({
    required this.id,
    required this.name,
    required this.type,
    required this.ext,
    this.pin,
    required this.path,
    required this.level,
    this.parentId,
    required this.size,
    required this.createdAt,
    this.updatedAt,
  });

  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceToJson(this);

  static Resource empty() => Resource(
        id: '',
        name: 'My Files',
        type: '',
        ext: '',
        path: '',
        level: 0,
        size: 0,
        createdAt: '',
      );

  Resource copyWith({
    String? id,
    String? name,
    String? type,
    String? ext,
    String? pin,
    String? path,
    int? level,
    String? parentId,
    int? size,
    String? createdAt,
    String? updatedAt,
  }) =>
      Resource(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        ext: ext ?? this.ext,
        pin: pin ?? this.pin,
        path: path ?? this.path,
        level: level ?? this.level,
        parentId: parentId ?? this.parentId,
        size: size ?? this.size,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
