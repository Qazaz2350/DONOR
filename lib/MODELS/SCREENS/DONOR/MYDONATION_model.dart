//
class DonationModel {
  final String foundationId;
  final String foundationName;
  final String category;
  final double? amount;
  final int? quantity;
  final String notes;
  final DateTime timestamp;

  DonationModel({
    required this.foundationId,
    required this.foundationName,
    required this.category,
    this.amount,
    this.quantity,
    required this.notes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'foundationId': foundationId,
      'foundationName': foundationName,
      'category': category,
      'amount': amount,
      'quantity': quantity,
      'notes': notes,
      'timestamp': timestamp,
    };
  }
}
