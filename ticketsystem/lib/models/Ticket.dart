class Ticket {
  final String id;
  final String eventName;
  final DateTime purchasedOn;
  final DateTime expiredOn;
  final String location;
  final DateTime startTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Ticket({
    required this.id,
    required this.eventName,
    required this.purchasedOn,
    required this.expiredOn,
    required this.location,
    required this.startTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'],
      eventName: json['eventName'],
      purchasedOn: DateTime.parse(json['purchasedOn']),
      expiredOn: DateTime.parse(json['expiredOn']),
      location: json['location'],
      startTime: DateTime.parse(json['startTime']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'eventName': eventName,
      'purchasedOn': purchasedOn.toIso8601String(),
      'expiredOn': expiredOn.toIso8601String(),
      'location': location,
      'startTime': startTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
