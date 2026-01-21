import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_waiting_view.dart';
import 'package:donate/SERVICES/orphanage_firebase_service.dart';

class OrphanageViewModel extends ChangeNotifier {
  // ===== Form Controllers =====
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cnicController = TextEditingController();

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
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      _showSnack(context, 'Please fill all fields including CNIC');
      return;
    }

    try {
      await OrphanageFirebaseService.submitOrphanageProfile(
        uid: currentUid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        cnic: cnicController.text.trim(),
        cnicImage: cnicImage,
        signboardImage: signboardImage,
        orphanageImage: orphanageImage,
        needs: [],
        status: "AdminApprovalWaiting",
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

    // ===== Map controllers to OFFD variables =====
    final offd_fullname = nameController.text.trim();
    final offd_email = emailController.text.trim();
    final offd_phone = phoneController.text.trim();
    final offd_address = addressController.text.trim();
    final offd_cnic = cnicController.text.trim();

    try {
      await OrphanageFirebaseService.submitOffdOrphanageProfile(
        uid: currentUid,
        offd_fullname: offd_fullname,
        offd_email: offd_email,
        offd_phone: offd_phone,
        offd_address: offd_address,
        offd_cnic: offd_cnic,
        offd_cnicImage: cnicImage,
        offd_signboardImage: signboardImage,
        offd_orphanageImage: orphanageImage,
        offd_needs: needs ?? [],
        offd_images: images ?? [],
        offd_stories: stories ?? [],
        offd_volunteeringEvents: volunteeringEvents ?? [],
        offd_verified: verified,
        offd_status: 'AdminApprovalWaiting',
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cnicController.dispose();
    super.dispose();
  }
}
