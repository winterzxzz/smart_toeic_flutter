// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) => Blog(
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      image: json['image'] as String?,
      view: (json['view'] as num?)?.toInt(),
      category: json['category'] as String?,
      isPublished: json['isPublished'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'author': instance.author,
      'image': instance.image,
      'view': instance.view,
      'category': instance.category,
      'isPublished': instance.isPublished,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'id': instance.id,
    };
