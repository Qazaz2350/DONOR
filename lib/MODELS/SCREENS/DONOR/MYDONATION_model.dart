class Donation {
  final String type; // Money, Food, Clothes, Books, Toys
  final String orphanageName;
  final double? amount; // only for Money type
  final String status; // Pending, Shipped, Delivered
  final DateTime date;

  Donation({
    required this.type,
    required this.orphanageName,
    this.amount,
    required this.status,
    required this.date,
  });
}

// WISH WALL MODEL

class WishModel {
  final String id;
  final String childName;
  final String wishTitle;
  final String description;
  final bool isFulfilled;

  WishModel({
    required this.id,
    required this.childName,
    required this.wishTitle,
    required this.description,
    required this.isFulfilled,
  });
}
