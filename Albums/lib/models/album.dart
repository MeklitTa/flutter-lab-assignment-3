class Album {
  final int id;
  final int userId;
  final String title;
  final String imageUrl;

  Album({
    required this.id,
    required this.userId,
    required this.title,
    required this.imageUrl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
} 