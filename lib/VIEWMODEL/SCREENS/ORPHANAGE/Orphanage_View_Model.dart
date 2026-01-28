import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_waiting_view.dart';
import 'package:donate/SERVICES/orphanage_firebase_service.dart';
import 'package:geolocator/geolocator.dart';

class OrphanageViewModel extends ChangeNotifier {
  // ===== Form Controllers =====
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cnicController = TextEditingController();
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
        // status: 'AdminApprovalWaiting',
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

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnack(context, 'Location services are disabled.');
      isLocationLoading = false;
      notifyListeners();
      return;
    }

    // Check for location permissions
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
      // Get current position
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

  // ===== Orphanage data fetched from Firestore =====
  // ===== Orphanage profile fields =====
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
    super.dispose();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===== Existing fields =====
  List<Map<String, dynamic>> videoCallRequests = [];
  bool isLoadingVideoCalls = false;

  /// Fetch all video call requests from Firestore
  Future<void> fetchVideoCallRequests() async {
    if (orphanagename == null) return; // Make sure we have orphanage name

    isLoadingVideoCalls = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('videocallrequest').get();

      // Filter and convert docs to Map<String, dynamic>
      videoCallRequests = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // keep doc ID
            return data;
          })
          .where(
            (req) =>
                req['orphanageName'] != null &&
                req['orphanageName'] == orphanagename &&
                (req['status'] == null || req['status'] == 'Pending'),
          ) // optional: only pending
          .toList();
    } catch (e) {
      print('Error fetching video call requests: $e');
    }

    isLoadingVideoCalls = false;
    notifyListeners();
  }

  /// ===== Accept a video call request =====
  Future<void> acceptVideoCall(String requestId, BuildContext context) async {
    try {
      await _firestore.collection('videocallrequest').doc(requestId).update({
        'videocallstatus': 'accepted',
      }); // update status

      // Optional: show feedback
      _showSnack(context, 'Video call request accepted');

      // Update local list to reflect change immediately
      videoCallRequests = videoCallRequests.map((req) {
        if (req['id'] == requestId) {
          req['videocallstatus'] = 'accepted';
        }
        return req;
      }).toList();

      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error accepting request: $e');
    }
  }

  /// ===== Reject a video call request =====
  Future<void> rejectVideoCall(String requestId, BuildContext context) async {
    try {
      await _firestore.collection('videocallrequest').doc(requestId).update({
        'videocallstatus': 'rejected',
      }); // update status

      // Optional: show feedback
      _showSnack(context, 'Video call request rejected');

      // Update local list to reflect change immediately
      videoCallRequests = videoCallRequests.map((req) {
        if (req['id'] == requestId) {
          req['videocallstatus'] = 'rejected';
        }
        return req;
      }).toList();

      notifyListeners();
    } catch (e) {
      _showSnack(context, 'Error rejecting request: $e');
    }
  }
}
