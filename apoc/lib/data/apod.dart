class Apod {
  final DateTime date;
  final String title;
  final String explanation;
  final String mediaType;
  final String hdurl;
  final String url;

  const Apod({
    required this.date,
    required this.title,
    required this.explanation,
    required this.mediaType,
    required this.hdurl,
    required this.url,
  });

  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      mediaType: json['media_type'] as String,
      hdurl: json['hdurl'] as String,
      url: json['url'] as String,
    );
  }
}