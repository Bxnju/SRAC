class History {
  final int id;
  List<DateTime> dates;
  List<String> humidity;

  History({
    required this.id,
    this.dates = const [],
    this.humidity = const [],

  });
}
