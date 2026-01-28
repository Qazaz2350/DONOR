class OrphanageModel {
  final String uid;
  final String name;
  final String address;
  final String cnic;
  final String cnicImage;
  final String signBoardImage;
  final String orphanageImage;
  final String status;
  final double latitude;
  final double longitude;

  final List<String> needs;
  final List<String> additionalImages;
  final List<Map<String, dynamic>> stories;
  final List<Map<String, dynamic>> volunteeringEvents;
  final bool verified;

  OrphanageModel({
    required this.uid,
    required this.name,
    required this.address,
    required this.cnic,
    required this.cnicImage,
    required this.signBoardImage,
    required this.orphanageImage,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.needs,
    required this.additionalImages,
    required this.stories,
    required this.volunteeringEvents,
    required this.verified,
  });

  factory OrphanageModel.fromJson(String uid, Map<String, dynamic> json) {
    return OrphanageModel(
      uid: uid,
      name: json['orphanagename'] ?? '',
      address: json['orphanageaddress'] ?? '',
      cnic: json['cnic'] ?? '',
      cnicImage: json['cnicImage'] ?? '',
      signBoardImage: json['signBoardImage'] ?? '',
      orphanageImage: json['orphanageImage'] ?? '',
      status: json['status'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      needs: List<String>.from(json['needs'] ?? []),
      additionalImages: List<String>.from(json['additionalImages'] ?? []),
      stories: List<Map<String, dynamic>>.from(json['stories'] ?? []),
      volunteeringEvents: List<Map<String, dynamic>>.from(
        json['volunteeringEvents'] ?? [],
      ),
      verified: json['verified'] ?? false,
    );
  }
}
