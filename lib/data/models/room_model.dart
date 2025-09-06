class RoomModel {
  final String id;
  final String title;
  final String description;
  final String creator;
  final int viewCount;
  final String imageUrl;
  final String? category;
  final bool isLive;

  const RoomModel({
    required this.id,
    required this.title,
    required this.description,
    required this.creator,
    required this.viewCount,
    required this.imageUrl,
    this.category,
    this.isLive = false,
  });

  String get formattedViewCount {
    if (viewCount >= 10000) {
      return '${(viewCount / 10000).toStringAsFixed(1)}万';
    }
    return viewCount.toString();
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      creator: json['creator'] as String,
      viewCount: json['viewCount'] as int,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String?,
      isLive: json['isLive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creator': creator,
      'viewCount': viewCount,
      'imageUrl': imageUrl,
      'category': category,
      'isLive': isLive,
    };
  }
}
