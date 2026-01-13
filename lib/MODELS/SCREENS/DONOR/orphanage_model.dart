// lib/models/orphanage_dummy.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String donorId;
  final String type; // Money / Clothes / Books / Toy
  final int quantity;
  final DateTime date;
  final double? amount;

  DonationModel({
    required this.donorId,
    required this.type,
    required this.quantity,
    required this.date,
    this.amount,
  });

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      donorId: map['donorId'] ?? '',
      type: map['type'] ?? '',
      quantity: map['quantity'] ?? 0,
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
      amount: map['amount']?.toDouble(),
    );
  }
}

class StoryModel {
  final String title;
  final String content;
  final List<String> images;
  final DateTime date;

  StoryModel({
    required this.title,
    required this.content,
    this.images = const [],
    required this.date,
  });

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int capacity;
  final int registered;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.capacity,
    required this.registered,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
      capacity: map['capacity'] ?? 0,
      registered: map['registered'] ?? 0,
    );
  }
}

class OrphanageModel {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool verified;
  final String description;
  final List<String> images;
  final List<String> videos;
  final List<String> needs;
  final Map<String, int> donationStock;
  final List<DonationModel> donationHistory;
  final List<StoryModel> stories;
  final List<EventModel> volunteeringEvents;
  final String arThankYouMarker;
  final String contactEmail;
  final String contactPhone;

  OrphanageModel({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    required this.verified,
    required this.description,
    this.images = const [],
    this.videos = const [],
    this.needs = const [],
    this.donationStock = const {},
    this.donationHistory = const [],
    this.stories = const [],
    this.volunteeringEvents = const [],
    this.arThankYouMarker = '',
    this.contactEmail = '',
    this.contactPhone = '',
  });

  factory OrphanageModel.fromMap(Map<String, dynamic> map, String id) {
    return OrphanageModel(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude'],
      longitude: map['longitude'],
      verified: map['verified'] ?? false,
      description: map['description'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      videos: List<String>.from(map['videos'] ?? []),
      needs: List<String>.from(map['needs'] ?? []),
      donationStock: Map<String, int>.from(map['donationStock'] ?? {}),
      donationHistory: (map['donationHistory'] as List<dynamic>? ?? [])
          .map((e) => DonationModel.fromMap(e))
          .toList(),
      stories: (map['stories'] as List<dynamic>? ?? [])
          .map((e) => StoryModel.fromMap(e))
          .toList(),
      volunteeringEvents: (map['volunteeringEvents'] as List<dynamic>? ?? [])
          .map((e) => EventModel.fromMap(e))
          .toList(),
      arThankYouMarker: map['arThankYouMarker'] ?? '',
      contactEmail: map['contactEmail'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
    );
  }
}

// ------------------ Dummy Data ------------------

final List<OrphanageModel> dummyOrphanages = [
  OrphanageModel(
    id: '1',
    name: 'Bright Future Orphanage',
    address: 'Karachi, Pakistan',
    latitude: 24.8607,
    longitude: 67.0011,
    verified: true,
    description: 'Caring for children and providing education and basic needs.',
    images: ['https://picsum.photos/200/300', 'https://picsum.photos/200/301'],
    needs: ['Food', 'Clothes', 'Books'],
    donationStock: {'Food': 50, 'Clothes': 30, 'Books': 20},
    donationHistory: [
      DonationModel(
        donorId: 'donor1',
        type: 'Money',
        quantity: 1,
        amount: 5000,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      DonationModel(
        donorId: 'donor2',
        type: 'Clothes',
        quantity: 10,
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ],
    stories: [
      StoryModel(
        title: 'School Supplies Distributed',
        content: 'We successfully distributed school supplies to 50 children.',
        images: ['https://picsum.photos/200/302'],
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ],
    volunteeringEvents: [
      EventModel(
        id: 'event1',
        title: 'Tree Plantation',
        description: 'Volunteers will plant trees in orphanage grounds.',
        date: DateTime.now().add(const Duration(days: 5)),
        capacity: 20,
        registered: 5,
      ),
    ],
    arThankYouMarker: 'assets/ar_markers/marker1.png',
    contactEmail: 'contact@brightfuture.org',
    contactPhone: '+92 300 1234567',
  ),
  OrphanageModel(
    id: '2',
    name: 'Little Stars Home',
    address: 'Lahore, Pakistan',
    latitude: 31.5204,
    longitude: 74.3587,
    verified: false,
    description:
        'Providing shelter and education for underprivileged children.',
    images: ['https://picsum.photos/200/303', 'https://picsum.photos/200/304'],
    needs: ['Toys', 'Clothes'],
    donationStock: {'Toys': 15, 'Clothes': 25},
    donationHistory: [],
    stories: [],
    volunteeringEvents: [],
    arThankYouMarker: 'assets/ar_markers/marker2.png',
    contactEmail: 'info@littlestars.org',
    contactPhone: '+92 300 9876543',
  ),
  OrphanageModel(
    id: '3',
    name: 'Helping Hands Orphanage',
    address: 'Islamabad, Pakistan',
    latitude: 33.6844,
    longitude: 73.0479,
    verified: true,
    description:
        'Empowering children through education and mentorship programs.',
    images: ['https://picsum.photos/200/305'],
    needs: ['Books', 'Food', 'Shoes'],
    donationStock: {'Books': 40, 'Food': 60, 'Shoes': 20},
    donationHistory: [
      DonationModel(
        donorId: 'donor3',
        type: 'Food',
        quantity: 30,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    stories: [
      StoryModel(
        title: 'Annual Sports Day',
        content:
            'We celebrated Sports Day with all the children participating.',
        images: ['https://picsum.photos/200/306'],
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ],
    volunteeringEvents: [
      EventModel(
        id: 'event2',
        title: 'Art Workshop',
        description: 'Volunteers will teach painting and crafts to children.',
        date: DateTime.now().add(const Duration(days: 10)),
        capacity: 15,
        registered: 3,
      ),
    ],
    arThankYouMarker: 'assets/ar_markers/marker3.png',
    contactEmail: 'hello@helpinghands.org',
    contactPhone: '+92 300 1112223',
  ),
  OrphanageModel(
    id: '4',
    name: 'Bright Futures Orphanage',
    address: 'Karachi, Pakistan',
    latitude: 24.8607,
    longitude: 67.0011,
    verified: true,
    description: 'Providing education and basic needs for children.',
    images: ['https://picsum.photos/200/307', 'https://picsum.photos/200/308'],
    needs: ['Books', 'Clothes', 'Food', 'Toys'],
    donationStock: {'Books': 30, 'Clothes': 40, 'Food': 50, 'Toys': 20},
    donationHistory: [
      DonationModel(
        donorId: 'donor4',
        type: 'Clothes',
        quantity: 10,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
    stories: [
      StoryModel(
        title: 'Annual Sports Day',
        content:
            'We celebrated Sports Day with all the children participating.',
        images: ['https://picsum.photos/200/309'],
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ],
    volunteeringEvents: [
      EventModel(
        id: 'event3',
        title: 'Art Workshop',
        description: 'Volunteers will teach painting and crafts to children.',
        date: DateTime.now().add(const Duration(days: 10)),
        capacity: 15,
        registered: 3,
      ),
    ],
    arThankYouMarker: 'assets/ar_markers/marker4.png',
    contactEmail: 'contact@brightfuture.org',
    contactPhone: '+92 300 1234567',
  ),
];
