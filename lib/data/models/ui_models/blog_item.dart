class BlogItem {
  final String imageUrl;
  final String title;
  final String description;
  final int countComments;
  final int countViews;
  final String date;

  BlogItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.countComments,
    required this.countViews,
    required this.date,
  });
}
