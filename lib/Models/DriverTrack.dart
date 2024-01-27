class Driver {
  final String name;
  final String username;
  final double late;
  final double long;
  final String img;
  final String date;

  Driver({
    required this.date,
    required this.late,
    required this.long,
    required this.name,
    required this.username,
    this.img = "",
  });
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      date: json['updatedAt'],
      late: json['late'],
      long: json['long'],
      username: json['username'],
      img: json['img'],
      name: json['name'],
    );
  }
}
