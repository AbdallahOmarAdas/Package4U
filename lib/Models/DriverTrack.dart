class Driver {
  final String name;
  final String username;
  final double late;
  final double long;
  final String img;

  Driver({
    required this.late,
    required this.long,
    required this.name,
    required this.username,
    required this.img,
  });
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      late: json['late'],
      long: json['long'],
      username: json['username'],
      img: json['img'],
      name: json['name'],
    );
  }
}
