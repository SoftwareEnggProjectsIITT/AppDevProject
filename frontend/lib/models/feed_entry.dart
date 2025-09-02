class FeedEntry {
  final String postId;
  final double score;

  FeedEntry({required this.postId, required this.score});

  factory FeedEntry.fromMap(Map<String, dynamic> map) {
    final postId = map.keys.first;
    final score = (map.values.first as num).toDouble();
    return FeedEntry(postId: postId, score: score);
  }
}

