import 'package:cloud_firestore/cloud_firestore.dart';

class OrphanageModel {
  String id;
  String OFD_name;
  String OFD_address;
  String OFD_email;
  String OFD_phone;
  bool OFD_verified;
  List<String> OFD_images;
  List<String> OFD_additionalNeeds;
  List<Story> OFD_stories;
  List<VolunteeringEvent> OFD_volunteeringEvents;
  Timestamp? OFD_createdAt;

  OrphanageModel({
    this.id = '',
    required this.OFD_name,
    required this.OFD_address,
    required this.OFD_email,
    required this.OFD_phone,
    this.OFD_verified = false,
    List<String>? OFD_images,
    List<String>? OFD_additionalNeeds,
    List<Story>? OFD_stories,
    List<VolunteeringEvent>? OFD_volunteeringEvents,
    this.OFD_createdAt,
  }) : OFD_images = OFD_images ?? [],
       OFD_additionalNeeds = OFD_additionalNeeds ?? [],
       OFD_stories = OFD_stories ?? [],
       OFD_volunteeringEvents = OFD_volunteeringEvents ?? [];

  // ===== From Firestore =====
  factory OrphanageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrphanageModel(
      id: doc.id,
      OFD_name: data['OFD_name'] ?? '',
      OFD_address: data['OFD_address'] ?? '',
      OFD_email: data['OFD_email'] ?? '',
      OFD_phone: data['OFD_phone'] ?? '',
      OFD_verified: data['OFD_verified'] ?? false,
      OFD_images: List<String>.from(data['OFD_images'] ?? []),
      OFD_additionalNeeds: List<String>.from(data['OFD_additionalNeeds'] ?? []),
      OFD_stories:
          (data['OFD_stories'] as List<dynamic>?)
              ?.map((e) => Story.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      OFD_volunteeringEvents:
          (data['OFD_volunteeringEvents'] as List<dynamic>?)
              ?.map(
                (e) => VolunteeringEvent.fromMap(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          [],
      OFD_createdAt: data['OFD_createdAt'],
    );
  }

  // ===== To Firestore =====
  Map<String, dynamic> toFirestore() {
    return {
      'OFD_name': OFD_name,
      'OFD_address': OFD_address,
      'OFD_email': OFD_email,
      'OFD_phone': OFD_phone,
      'OFD_verified': OFD_verified,
      'OFD_images': OFD_images,
      'OFD_additionalNeeds': OFD_additionalNeeds,
      'OFD_stories': OFD_stories.map((s) => s.toMap()).toList(),
      'OFD_volunteeringEvents': OFD_volunteeringEvents.map(
        (e) => e.toMap(),
      ).toList(),
      'OFD_createdAt': OFD_createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

// ===== Story Model =====
class Story {
  String OFD_title;
  String OFD_content;
  DateTime OFD_date;

  Story({
    required this.OFD_title,
    required this.OFD_content,
    required this.OFD_date,
  });

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      OFD_title: map['OFD_title'] ?? '',
      OFD_content: map['OFD_content'] ?? '',
      OFD_date: (map['OFD_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'OFD_title': OFD_title,
      'OFD_content': OFD_content,
      'OFD_date': OFD_date,
    };
  }
}

// ===== Volunteering Event Model =====
class VolunteeringEvent {
  String OFD_id;
  String OFD_title;
  String OFD_description;
  int OFD_capacity;
  int OFD_registered;
  DateTime OFD_date;

  VolunteeringEvent({
    required this.OFD_id,
    required this.OFD_title,
    required this.OFD_description,
    required this.OFD_capacity,
    required this.OFD_registered,
    required this.OFD_date,
  });

  factory VolunteeringEvent.fromMap(Map<String, dynamic> map) {
    return VolunteeringEvent(
      OFD_id: map['OFD_id'] ?? '',
      OFD_title: map['OFD_title'] ?? '',
      OFD_description: map['OFD_description'] ?? '',
      OFD_capacity: map['OFD_capacity'] ?? 0,
      OFD_registered: map['OFD_registered'] ?? 0,
      OFD_date: (map['OFD_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'OFD_id': OFD_id,
      'OFD_title': OFD_title,
      'OFD_description': OFD_description,
      'OFD_capacity': OFD_capacity,
      'OFD_registered': OFD_registered,
      'OFD_date': OFD_date,
    };
  }
}
