import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_waiting_view.dart';
import 'package:donate/SERVICES/orphanage_firebase_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OrphanageViewModel extends ChangeNotifier {
  // ===== Form Controllers =====
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cnicController = TextEditingController();

  // ADD THESE NEW CONTROLLERS FOR EDITING
  final needsController = TextEditingController();
  final storyTitleController = TextEditingController();
  final storyDescriptionController = TextEditingController();
  final eventTitleController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventTimeController = TextEditingController();

  // location
  double? latitude;
  double? longitude;
  bool isLocationLoading = false;

  // ===== Image holders =====
  File? cnicImage;
  File? signboardImage;
  File? orphanageImage;

  // ===== Form key =====
  final formKey = GlobalKey<FormState>();
  bool validateForm() => formKey.currentState?.validate() ?? false;

  // ===== Verification status =====
  bool isVerified = false;

  // ===== Current UID =====
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  // ===== ADD FIREBASE STORAGE INSTANCE =====
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===== Submit Orphanage (Standard Signup) =====
  Future<void> submitOrphanage(BuildContext context) async {
    final currentUid = uid;
    if (currentUid == null) {
      _showSnack(context, 'User not signed in');
      return;
    }

    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      _showSnack(context, 'Please fill all fields including CNIC');
      return;
    }

    try {
      await OrphanageFirebaseService.submitOrphanageProfile(
        uid: currentUid,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        cnic: cnicController.text.trim(),
        cnicImage: cnicImage,
        signboardImage: signboardImage,
        orphanageImage: orphanageImage,
        status: "AdminApprovalWaiting",
        latitude: latitude,
        longitude: longitude,
      );

      _showSnack(context, 'Orphanage profile submitted for verification');
      Nav.push(context, OrphanagWaitingView());

      isVerified = true;
      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error: $e');
    }
  }

  // ===== Submit OFFD Orphanage (Full Fields) =====
  Future<void> submitOffdOrphanage(
    BuildContext context, {
    List<String>? images,
    List<String>? needs,
    List<Map<String, dynamic>>? stories,
    List<Map<String, dynamic>>? volunteeringEvents,
    bool verified = false,
  }) async {
    final currentUid = uid;
    if (currentUid == null) {
      _showSnack(context, 'User not signed in');
      return;
    }

    try {
      await OrphanageFirebaseService.submitOffdOrphanageProfile(
        uid: currentUid,
        cnicImage: cnicImage,
        signboardImage: signboardImage,
        orphanageImage: orphanageImage,
        needs: needs ?? [],
        images: images ?? [],
        stories: stories ?? [],
        volunteeringEvents: volunteeringEvents ?? [],
        verified: verified,
      );

      _showSnack(context, 'OFFD Orphanage profile submitted for verification');
      isVerified = true;
      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error: $e');
    }
  }

  // ===== Helper method for SnackBar =====
  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Fetch live location from device
  Future<void> fetchLiveLocation(BuildContext context) async {
    isLocationLoading = true;
    notifyListeners();

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnack(context, 'Location services are disabled.');
      isLocationLoading = false;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnack(context, 'Location permission denied.');
        isLocationLoading = false;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnack(
        context,
        'Location permission permanently denied. Please enable from settings.',
      );
      isLocationLoading = false;
      notifyListeners();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;
      _showSnack(context, 'Location fetched successfully.');
    } catch (e) {
      _showSnack(context, 'Failed to get location: $e');
    }

    isLocationLoading = false;
    notifyListeners();
  }

  // ===== EDIT METHODS FOR NEEDS, STORIES, EVENTS =====

  // For Needs editing
  bool isEditingNeeds = false;

  void toggleEditNeeds() {
    isEditingNeeds = !isEditingNeeds;
    if (isEditingNeeds) {
      needsController.text = needs.join(', ');
    }
    notifyListeners();
  }

  Future<void> saveNeeds(BuildContext context) async {
    final currentUid = uid;
    if (currentUid == null) return;

    try {
      // Split by commas and trim
      List<String> newNeeds = needsController.text
          .split(',')
          .map((need) => need.trim())
          .where((need) => need.isNotEmpty)
          .toList();

      // Update local state
      needs = newNeeds;

      // Update Firestore
      await _firestore.collection('orphanage').doc(currentUid).update({
        'needs': newNeeds,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSnack(context, 'Needs updated successfully');
      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error updating needs: $e');
    }
  }

  // FIXED: This method now saves to Firebase
  Future<void> addNeed(String need, BuildContext context) async {
    final currentUid = uid;
    if (currentUid == null) return;

    if (need.trim().isNotEmpty) {
      try {
        // Add to local list
        needs.add(need.trim());

        // Save to Firebase
        await _firestore.collection('orphanage').doc(currentUid).update({
          'needs': needs,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        _showSnack(context, 'Need added successfully');
        notifyListeners();
      } catch (e) {
        _showSnack(context, 'Error adding need: $e');
        // Rollback on error
        if (needs.isNotEmpty) needs.removeLast();
      }
    }
  }

  Future<void> removeNeed(BuildContext context, int index) async {
    final currentUid = uid;
    if (currentUid == null) return;

    if (index >= 0 && index < needs.length) {
      try {
        needs.removeAt(index);

        await _firestore.collection('orphanage').doc(currentUid).update({
          'needs': needs,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        _showSnack(context, 'Need removed successfully');
        notifyListeners();
      } catch (e) {
        _showSnack(context, 'Error removing need: $e');
      }
    }
  }

  // FIXED: Added this method for bulk editing from UI
  Future<void> saveNeedsFromList(
    BuildContext context,
    List<String> newNeeds,
  ) async {
    final currentUid = uid;
    if (currentUid == null) return;

    try {
      // Update local state
      needs = newNeeds;

      // Update Firestore
      await _firestore.collection('orphanage').doc(currentUid).update({
        'needs': newNeeds,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSnack(context, 'Needs updated successfully');
      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error updating needs: $e');
    }
  }

  // For Stories editing
  bool isAddingStory = false;

  void toggleAddStory() {
    isAddingStory = !isAddingStory;
    if (!isAddingStory) {
      storyTitleController.clear();
      storyDescriptionController.clear();
    }
    notifyListeners();
  }

  Future<void> addStory(BuildContext context) async {
    final currentUid = uid;
    if (currentUid == null) return;

    if (storyTitleController.text.trim().isEmpty ||
        storyDescriptionController.text.trim().isEmpty) {
      _showSnack(context, 'Please fill title and description');
      return;
    }

    try {
      final newStory = {
        'title': storyTitleController.text.trim(),
        'description': storyDescriptionController.text.trim(),
        'date': DateTime.now().toIso8601String(),
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      // Step 1: LOCAL update (immediate UI refresh)
      stories.add(newStory);
      notifyListeners();

      // Step 2: Save to Firestore
      await _firestore.collection('orphanage').doc(currentUid).update({
        'stories': stories,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSnack(context, 'Story added successfully');

      // Clear controllers
      storyTitleController.clear();
      storyDescriptionController.clear();
    } catch (e) {
      _showSnack(context, 'Error adding story: $e');
      // Rollback on error
      if (stories.isNotEmpty) stories.removeLast();
      notifyListeners();
    }
  }

  Future<void> removeStory(BuildContext context, int index) async {
    final currentUid = uid;
    if (currentUid == null) return;

    if (index >= 0 && index < stories.length) {
      try {
        stories.removeAt(index);

        await _firestore.collection('orphanage').doc(currentUid).update({
          'stories': stories,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        _showSnack(context, 'Story removed successfully');
        notifyListeners();
      } catch (e) {
        _showSnack(context, 'Error removing story: $e');
      }
    }
  }

  // For Volunteering Events editing
  bool isAddingEvent = false;

  void toggleAddEvent() {
    isAddingEvent = !isAddingEvent;
    if (!isAddingEvent) {
      eventTitleController.clear();
      eventDescriptionController.clear();
      eventDateController.clear();
      eventTimeController.clear();
    }
    notifyListeners();
  }

  Future<void> addVolunteeringEvent(BuildContext context) async {
    final currentUid = uid;
    if (currentUid == null) return;

    if (eventTitleController.text.trim().isEmpty ||
        eventDescriptionController.text.trim().isEmpty ||
        eventDateController.text.trim().isEmpty ||
        eventTimeController.text.trim().isEmpty) {
      _showSnack(context, 'Please fill all event fields');
      return;
    }

    try {
      final newEvent = {
        'title': eventTitleController.text.trim(),
        'description': eventDescriptionController.text.trim(),
        'date': eventDateController.text.trim(),
        'time': eventTimeController.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      volunteeringEvents.add(newEvent);

      await _firestore.collection('orphanage').doc(currentUid).update({
        'volunteeringEvents': volunteeringEvents,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSnack(context, 'Event added successfully');

      eventTitleController.clear();
      eventDescriptionController.clear();
      eventDateController.clear();
      eventTimeController.clear();
      isAddingEvent = false;
      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error adding event: $e');
    }
  }

  // Add this method to your ViewModel
  Future<void> addVolunteeringEventWithData(
    BuildContext context, {
    required String title,
    required String description,
    required String date,
    required String time,
  }) async {
    final currentUid = uid;
    if (currentUid == null) return;

    try {
      final newEvent = {
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'createdAt': DateTime.now().toIso8601String(),
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      // Add to local list
      volunteeringEvents.add(newEvent);
      notifyListeners();

      // Save to Firestore
      await _firestore.collection('orphanage').doc(currentUid).update({
        'volunteeringEvents': volunteeringEvents,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSnack(context, 'Event added successfully');
    } catch (e) {
      _showSnack(context, 'Error adding event: $e');
      // Rollback
      if (volunteeringEvents.isNotEmpty) volunteeringEvents.removeLast();
      notifyListeners();
    }
  }

  Future<void> removeEvent(BuildContext context, int index) async {
    final currentUid = uid;
    if (currentUid == null) return;

    if (index >= 0 && index < volunteeringEvents.length) {
      try {
        volunteeringEvents.removeAt(index);

        await _firestore.collection('orphanage').doc(currentUid).update({
          'volunteeringEvents': volunteeringEvents,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        _showSnack(context, 'Event removed successfully');
        notifyListeners();
      } catch (e) {
        _showSnack(context, 'Error removing event: $e');
      }
    }
  }

  // For Additional Images editing
  bool isAddingImages = false;

  // Future<void> addImage(BuildContext context, File imageFile) async {
  //   final currentUid = uid;
  //   if (currentUid == null) return;

  //   try {
  //     final ref = _storage.ref(
  //       'orphanages/$currentUid/gallery/${DateTime.now().millisecondsSinceEpoch}.jpg',
  //     );
  //     await ref.putFile(imageFile);
  //     final imageUrl = await ref.getDownloadURL();

  //     additionalImages.add(imageUrl);

  //     await _firestore.collection('orphanage').doc(currentUid).update({
  //       'additionalImages': additionalImages,
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     });

  //     _showSnack(context, 'Image added successfully');
  //     notifyListeners();
  //   } catch (e) {
  //     _showSnack(context, 'Error adding image: $e');
  //   }
  // }

  // Future<void> removeImage(BuildContext context, int index) async {
  //   final currentUid = uid;
  //   if (currentUid == null) return;

  //   if (index >= 0 && index < additionalImages.length) {
  //     try {
  //       additionalImages.removeAt(index);

  //       await _firestore.collection('orphanage').doc(currentUid).update({
  //         'additionalImages': additionalImages,
  //         'updatedAt': FieldValue.serverTimestamp(),
  //       });

  //       _showSnack(context, 'Image removed successfully');
  //       notifyListeners();
  //     } catch (e) {
  //       _showSnack(context, 'Error removing image: $e');
  //     }
  //   }
  // }

  // ===== Orphanage data fetched from Firestore =====
  String? orphanagename;
  String? orphanageaddress;
  String? cnic;
  String? signBoardImage;
  String? status;

  bool isLoadingProfile = false;

  /// Fetch orphanage profile from Firestore and save fields with same names
  Future<void> fetchOrphanageProfile() async {
    final currentUid = uid;
    if (currentUid == null) return;

    isLoadingProfile = true;
    notifyListeners();

    try {
      final data = await OrphanageFirebaseService.fetchOrphanageProfile(
        uid: currentUid,
      );

      if (data != null) {
        orphanagename = data['orphanagename'];
        orphanageaddress = data['orphanageaddress'];
        cnic = data['cnic'];
        cnicImage = data['cnicImage'];
        orphanageImage = data['orphanageImage'];
        status = data['status'];
      }
    } catch (e) {
      print('Error fetching orphanage profile: $e');
    }

    isLoadingProfile = false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cnicController.dispose();
    needsController.dispose();
    storyTitleController.dispose();
    storyDescriptionController.dispose();
    eventTitleController.dispose();
    eventDescriptionController.dispose();
    eventDateController.dispose();
    eventTimeController.dispose();
    super.dispose();
  }

  // ===== Existing fields =====
  List<Map<String, dynamic>> videoCallRequests = [];
  bool isLoadingVideoCalls = false;

  /// Fetch all video call requests from Firestore
  Future<void> fetchVideoCallRequests() async {
    if (orphanagename == null) return;

    isLoadingVideoCalls = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('videocallrequest').get();

      videoCallRequests = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          })
          .where(
            (req) =>
                req['orphanageName'] != null &&
                req['orphanageName'] == orphanagename &&
                (req['status'] == null || req['status'] == 'Pending'),
          )
          .toList();
    } catch (e) {
      print('Error fetching video call requests: $e');
    }

    isLoadingVideoCalls = false;
    notifyListeners();
  }

  /// ===== Accept a video call request =====
  Future<void> acceptVideoCallrequest(
    String requestId,
    BuildContext context,
  ) async {
    try {
      await _firestore.collection('videocallrequest').doc(requestId).update({
        'videocallstatus': 'RequestAccepted',
      });

      _showSnack(context, 'Video call request accepted');

      videoCallRequests = videoCallRequests.map((req) {
        if (req['id'] == requestId) {
          req['videocallstatus'] = 'RequestAccepted';
        }
        return req;
      }).toList();

      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error accepting request: $e');
    }
  }

  /// ===== Reject a video call request =====
  Future<void> rejectVideoCallrequest(
    String requestId,
    BuildContext context,
  ) async {
    try {
      await _firestore.collection('videocallrequest').doc(requestId).update({
        'videocallstatus': 'RequestRejected',
      });

      _showSnack(context, 'Video call request rejected');

      videoCallRequests = videoCallRequests.map((req) {
        if (req['id'] == requestId) {
          req['videocallstatus'] = 'RequestRejected';
        }
        return req;
      }).toList();

      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error rejecting request: $e');
    }
  }

  // ===== Fetch ALL Orphanages (Admin / Donor Side) =====
  List<Map<String, dynamic>> orphanageList = [];
  bool isLoadingOrphanages = false;

  Future<void> fetchAllOrphanages() async {
    isLoadingOrphanages = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('orphanage')
          .orderBy('createdAt', descending: true)
          .get();

      orphanageList = snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching orphanages: $e');
    }

    isLoadingOrphanages = false;
    notifyListeners();
  }

  // ===== Additional Orphanage fields =====
  String email = '';
  String phone = '';
  String address = '';

  // ===== Extra fields =====
  List<String> needs = [];
  List<String> additionalImages = [];
  List<Map<String, dynamic>> stories = [];
  List<Map<String, dynamic>> volunteeringEvents = [];
  bool verified = false;
  DateTime? createdAt;

  /// Fetch all fields for the signed-in orphanage
  Future<void> fetchMyProfile() async {
    final currentUid = uid;
    if (currentUid == null) return;

    try {
      final data = await OrphanageFirebaseService.fetchOrphanageProfile(
        uid: currentUid,
      );

      if (data != null) {
        // Basic info
        orphanagename = data['orphanagename'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        orphanageaddress = data['orphanageaddress'] ?? '';
        status = data['status'] ?? '';
        cnic = data['cnic'] ?? '';

        // Images
        cnicImage = data['cnicImage'];
        signboardImage = data['signBoardImage'];
        orphanageImage = data['orphanageImage'];

        // Location
        latitude = (data['latitude'] != null)
            ? (data['latitude'] as num).toDouble()
            : null;
        longitude = (data['longitude'] != null)
            ? (data['longitude'] as num).toDouble()
            : null;

        // Additional fields
        needs = List<String>.from(data['needs'] ?? []);
        additionalImages = List<String>.from(data['additionalImages'] ?? []);
        stories = List<Map<String, dynamic>>.from(data['stories'] ?? []);
        volunteeringEvents = List<Map<String, dynamic>>.from(
          data['volunteeringEvents'] ?? [],
        );
        verified = data['verified'] ?? false;
        createdAt = data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : null;

        notifyListeners();
      }
    } catch (e) {
      print('Error fetching orphanage profile: $e');
    }
  }
}
