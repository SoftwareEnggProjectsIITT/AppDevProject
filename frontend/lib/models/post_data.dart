class PostData {
  PostData({
    required this.body,
    required this.category,
    required this.data,
    required this.image_link,
    required this.likes,
    required this.title,
  });

  final String body;
  final String category;
  final String data;
  final String image_link;
  final int likes;
  final String title;

  factory PostData.fromJson(Map<dynamic, dynamic> json) {
    return PostData(
      body: json['body'] ?? '',
      category: json['category'] ?? '',
      data: json['data'] ?? '',
      image_link: json['image_link'] ?? '',
      likes: json['likes'] ?? 0,
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'category': category,
      'data': data,
      'image_link': image_link,
      'likes': likes,
      'title': title,
    };
  }
}

