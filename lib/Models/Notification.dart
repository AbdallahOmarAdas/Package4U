class CustomerNotification {
  final String Title;
  final String Body;
  final String Note;
  final String Status;
  final int PackageId;
  final DateTime Date;

  CustomerNotification({
    required this.Title,
    required this.Status,
    required this.Note,
    required this.PackageId,
    required this.Body,
    required this.Date,
  });
  factory CustomerNotification.fromJson(Map<String, dynamic> json) {
    return CustomerNotification(
      Title: json['title'],
      Body: json['body'],
      Date: DateTime.parse(json['dateTime']),
      PackageId: json['noti_packageId'],
      Status: json['status'],
      Note: json['note'],
    );
  }
}
