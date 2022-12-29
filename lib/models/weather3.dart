class News {
  late final String title;
  late final String url;
  late final String thumbnail;


  News({
    required this.title,
    required this.url,
    required this.thumbnail,
  });

  factory News.fromJson(dynamic json) {
    return News(
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }
  static List<News> newsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return News.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return '{"title": "$title", "url": $url, "thumbnail": $thumbnail}';
  }
}


