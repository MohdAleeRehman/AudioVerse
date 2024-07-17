class Audiobook {
  final String id;
  final String title;
  final String author;
  final String? coverImageUrl;
  final String? audioFileUrl;

  Audiobook({
    required this.id,
    required this.title,
    required this.author,
    this.coverImageUrl,
    this.audioFileUrl,
  });

  factory Audiobook.fromJson(Map<String, dynamic> json) {
    return Audiobook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverImageUrl: json['coverImageUrl'],
      audioFileUrl: json['audioFileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverImageUrl': coverImageUrl,
      'audioFileUrl': audioFileUrl,
    };
  }
}
