class PostData {
  PostData({
    required this.body,
    required this.category,
    required this.date,
    required this.image_link,
    required this.likes,
    required this.title,
  });

  final String body;
  final String category;
  final String date;
  final String image_link;
  int likes;
  final String title;
  String? id;

  factory PostData.fromJson(Map<dynamic, dynamic> json) {
    return PostData(
      body: json['body'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      image_link: json['image_link'] ?? '',
      likes: json['likes'] ?? 0,
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'category': category,
      'date': date,
      'image_link': image_link,
      'likes': likes,
      'title': title,
    };
  }
}

extension PostDataWithId on PostData {
  Map<String, dynamic> toJsonWithId() {
    final json = toJson();
    json['id'] = id;
    return json;
  }

  static PostData fromJsonWithId(Map<String, dynamic> json) {
    final post = PostData.fromJson(json);
    post.id = json['id'];
    return post;
  }
}
