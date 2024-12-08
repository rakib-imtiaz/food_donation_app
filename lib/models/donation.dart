class Donation {
  final String id;
  final String donorId;
  final String foodName;
  final String description;
  final int quantity;
  final String location;
  final DateTime pickupTime;
  final bool isClaimed;
  final String? claimedBy;

  Donation({
    required this.id,
    required this.donorId,
    required this.foodName,
    required this.description,
    required this.quantity,
    required this.location,
    required this.pickupTime,
    this.isClaimed = false,
    this.claimedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donorId': donorId,
      'foodName': foodName,
      'description': description,
      'quantity': quantity,
      'location': location,
      'pickupTime': pickupTime.toIso8601String(),
      'isClaimed': isClaimed ? 1 : 0,
      'claimedBy': claimedBy,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      id: map['id'],
      donorId: map['donorId'],
      foodName: map['foodName'],
      description: map['description'],
      quantity: map['quantity'],
      location: map['location'],
      pickupTime: DateTime.parse(map['pickupTime']),
      isClaimed: map['isClaimed'] == 1,
      claimedBy: map['claimedBy'],
    );
  }
} 