class Summary {
  final int notReceived;
  final int received;
  final int notDeliverd;
  final int deliverd;
  final double balance;

  Summary(
      {required this.balance,
      required this.deliverd,
      required this.notDeliverd,
      required this.notReceived,
      required this.received});
  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
        balance: json['balance'].toDouble(),
        deliverd: json['deliverd'],
        notDeliverd: json['notDelivered'],
        notReceived: json['notReceived'],
        received: json['received']);
  }
}
