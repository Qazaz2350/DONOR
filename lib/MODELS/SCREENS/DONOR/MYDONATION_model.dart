// models/all_models.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// ---------------------------
// EXISTING DONATION MODEL (NO CHANGES)
// ---------------------------
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

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      foundationId: map['foundationId'] ?? '',
      foundationName: map['foundationName'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] as num?)?.toDouble(),
      quantity: (map['quantity'] as num?)?.toInt(),
      notes: map['notes'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}

// ---------------------------
// NEW: ORPHANAGE MODEL
// ---------------------------
class OrphanageModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String status;
  final String? imageUrl;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrphanageModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.status,
    this.imageUrl,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory OrphanageModel.fromMap(Map<String, dynamic> map) {
    return OrphanageModel(
      uid: map['uid'] ?? '',
      name: map['orphanagename'] ?? map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      status: map['status'] ?? '',
      imageUrl: map['imageUrl'],
      description: map['description'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'orphanagename': name,
      'email': email,
      'phone': phone,
      'address': address,
      'status': status,
      'imageUrl': imageUrl,
      'description': description,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

// ---------------------------
// NEW: VIDEO CALL REQUEST MODEL
// ---------------------------
class VideoCallRequestModel {
  final String? id;
  final String callID;
  final String donorID;
  final String orphanageID;
  final String orphanageName;
  final String donorName;
  final String donorPhone;
  final String donorEmail;
  final DateTime scheduledTime;
  final DateTime requestTime;
  final String videocallstatus;
  final DateTime? actualCallStartTime;
  final DateTime? callEndTime;

  VideoCallRequestModel({
    this.id,
    required this.callID,
    required this.donorID,
    required this.orphanageID,
    required this.orphanageName,
    required this.donorName,
    required this.donorPhone,
    required this.donorEmail,
    required this.scheduledTime,
    required this.requestTime,
    required this.videocallstatus,
    this.actualCallStartTime,
    this.callEndTime,
  });

  factory VideoCallRequestModel.fromMap(Map<String, dynamic> map) {
    return VideoCallRequestModel(
      id: map['id'],
      callID: map['callID'] ?? '',
      donorID: map['donorID'] ?? '',
      orphanageID: map['orphanageID'] ?? '',
      orphanageName: map['orphanageName'] ?? '',
      donorName: map['donorName'] ?? '',
      donorPhone: map['donorPhone'] ?? '',
      donorEmail: map['donorEmail'] ?? '',
      scheduledTime: (map['scheduledTime'] as Timestamp).toDate(),
      requestTime: (map['requestTime'] as Timestamp).toDate(),
      videocallstatus: map['videocallstatus'] ?? 'pending',
      actualCallStartTime: map['actualCallStartTime'] != null
          ? (map['actualCallStartTime'] as Timestamp).toDate()
          : null,
      callEndTime: map['callEndTime'] != null
          ? (map['callEndTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callID': callID,
      'donorID': donorID,
      'orphanageID': orphanageID,
      'orphanageName': orphanageName,
      'donorName': donorName,
      'donorPhone': donorPhone,
      'donorEmail': donorEmail,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'requestTime': Timestamp.fromDate(requestTime),
      'videocallstatus': videocallstatus,
      'actualCallStartTime': actualCallStartTime != null
          ? Timestamp.fromDate(actualCallStartTime!)
          : null,
      'callEndTime': callEndTime != null
          ? Timestamp.fromDate(callEndTime!)
          : null,
    };
  }
}

// ---------------------------
// NEW: ACTIVE CALL MODEL
// ---------------------------
class ActiveCallModel {
  final String? id;
  final String callID;
  final String donorId;
  final String donorName;
  final String orphanageId;
  final String orphanageName;
  final DateTime startTime;
  final String status;
  final String? requestId;
  final DateTime? endTime;

  ActiveCallModel({
    this.id,
    required this.callID,
    required this.donorId,
    required this.donorName,
    required this.orphanageId,
    required this.orphanageName,
    required this.startTime,
    required this.status,
    this.requestId,
    this.endTime,
  });

  factory ActiveCallModel.fromMap(Map<String, dynamic> map) {
    return ActiveCallModel(
      id: map['id'],
      callID: map['callID'] ?? '',
      donorId: map['donorId'] ?? '',
      donorName: map['donorName'] ?? '',
      orphanageId: map['orphanageId'] ?? '',
      orphanageName: map['orphanageName'] ?? '',
      startTime: map['startTime'] != null
          ? (map['startTime'] is Timestamp)
                ? (map['startTime'] as Timestamp).toDate()
                : DateTime.parse(map['startTime'].toString())
          : DateTime.now(),
      status: map['status'] ?? 'active',
      requestId: map['requestId'],
      endTime: map['endTime'] != null
          ? (map['endTime'] is Timestamp)
                ? (map['endTime'] as Timestamp).toDate()
                : DateTime.parse(map['endTime'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callID': callID,
      'donorId': donorId,
      'donorName': donorName,
      'orphanageId': orphanageId,
      'orphanageName': orphanageName,
      'startTime': startTime,
      'status': status,
      'requestId': requestId,
      'endTime': endTime,
    };
  }
}

// ---------------------------
// NEW: DONOR MODEL
// ---------------------------
class DonorModel {
  final String uid;
  final String? fullName;
  final String email;
  final String phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DonorModel({
    required this.uid,
    this.fullName,
    required this.email,
    required this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory DonorModel.fromMap(Map<String, dynamic> map) {
    return DonorModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'],
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

// ---------------------------
// NEW: USER DONATIONS DOCUMENT MODEL
// ---------------------------
class UserDonationsDocument {
  final String userId;
  final String donorname;
  final String donoremail;
  final String donorphone;
  final List<DonationModel> donations;
  final DateTime createdAt;
  final DateTime lastUpdated;

  UserDonationsDocument({
    required this.userId,
    required this.donorname,
    required this.donoremail,
    required this.donorphone,
    required this.donations,
    required this.createdAt,
    required this.lastUpdated,
  });

  factory UserDonationsDocument.fromMap(Map<String, dynamic> map) {
    final donationsList = (map['donations'] as List<dynamic>?) ?? [];
    return UserDonationsDocument(
      userId: map['userId'] ?? '',
      donorname: map['donorname'] ?? '',
      donoremail: map['donoremail'] ?? '',
      donorphone: map['donorphone'] ?? '',
      donations: donationsList
          .map((d) => DonationModel.fromMap(Map<String, dynamic>.from(d)))
          .toList(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'donorname': donorname,
      'donoremail': donoremail,
      'donorphone': donorphone,
      'donations': donations.map((d) => d.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
