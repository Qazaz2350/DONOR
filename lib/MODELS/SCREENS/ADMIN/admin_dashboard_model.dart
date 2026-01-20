class OrphanageModel {
  final String id;
  final String name;
  final String address;
  final String verificationStatus; // pending / approved / rejected
  final String cnicImage;
  final String registrationDoc;
  final String signboardImage;
  final List<String> orphanageImages;

  OrphanageModel({
    required this.id,
    required this.name,
    required this.address,
    required this.verificationStatus,
    required this.cnicImage,
    required this.registrationDoc,
    required this.signboardImage,
    required this.orphanageImages,
  });

  factory OrphanageModel.fromJson(Map<String, dynamic> json) {
    return OrphanageModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      verificationStatus: json['verificationStatus'],
      cnicImage: json['cnicImage'],
      registrationDoc: json['registrationDoc'],
      signboardImage: json['signboardImage'],
      orphanageImages: List<String>.from(json['orphanageImages'] ?? []),
    );
  }
}
