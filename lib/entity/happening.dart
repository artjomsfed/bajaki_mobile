class Happening {

  final int id;
  final String title;
  final DateTime startDate;

  Happening({
    required this.id,
    required this.title,
    required this.startDate
  });

  factory Happening.fromJson(Map<String, dynamic> json) {
    return Happening(
        id: json['id'],
        title: json['title'],
        startDate: DateTime.parse(json['starts_at']['date']),
    );
  }

  @override
  String toString() {
    return '$title, starting: ${startDate.day}.${startDate.month}.${startDate.year}';
  }
}
