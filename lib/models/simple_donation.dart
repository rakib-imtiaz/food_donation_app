class SimpleDonation {
  final String id;
  final String foodName;
  final String description;
  final int quantity;
  final String location;
  final String pickupTime;

  SimpleDonation({
    required this.id,
    required this.foodName,
    required this.description,
    required this.quantity,
    required this.location,
    required this.pickupTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodName': foodName,
      'description': description,
      'quantity': quantity,
      'location': location,
      'pickupTime': pickupTime,
    };
  }

  factory SimpleDonation.fromMap(Map<String, dynamic> map) {
    return SimpleDonation(
      id: map['id'],
      foodName: map['foodName'],
      description: map['description'],
      quantity: map['quantity'],
      location: map['location'],
      pickupTime: map['pickupTime'],
    );
  }
} 