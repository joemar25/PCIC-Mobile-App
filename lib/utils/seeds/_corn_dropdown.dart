class Corn {
  static int _idCounter = 0;

  final int id;
  final String title;

  Corn({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Corn.fromMap(Map<String, dynamic> map) {
    return Corn(
      id: map['id'],
      title: map['title'],
    );
  }

  static Corn createSeed({required String title}) {
    final seed = Corn(id: _idCounter++, title: title);
    return seed;
  }

  static List<Corn> getAllSeeds() {
    return [
      Corn.createSeed(title: "blank test 1"),
      Corn.createSeed(title: "blank test 2"),
    ];
  }
}
