// import 'package:donate/Utilis/nav.dart';
// import 'package:donate/VIEW/SCREENS/ADMIN/admin_dashboard.dart';
// import 'package:donate/VIEW/SCREENS/DONOR/donor_tabbar_view.dart';
// import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_Form_view.dart';
// import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_dashboard_view.dart';
// import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_rejection_view.dart';
// import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_waiting_view.dart';
// import 'package:donate/VIEW/login/signin_view.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class LandingPage extends StatefulWidget {
//   const LandingPage({super.key});

//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
//   @override
//   void initState() {
//     super.initState();
//     _checkAuth();
//   }

//   Future<void> _checkAuth() async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       // Not signed in → go to SignIn page
//       Nav.pushReplacement(context, SignInScreenView());
//       return;
//     }

//     final email = user.email;

//     // Admin
//     if (email == "admin6677@gmail.com") {
//       Nav.pushReplacement(context, const AdminOrphanagePage());
//       return;
//     }

//     // Orphanage
//     final orphanageDoc = await FirebaseFirestore.instance
//         .collection('orphanage')
//         .doc(user.uid)
//         .get();

//     if (orphanageDoc.exists) {
//       final data = orphanageDoc.data();
//       final status = data?['status'] ?? '';

//       if (status == "OrphanageFormPending") {
//         Nav.pushReplacement(context, const OrphanageSignupView());
//       } else if (status == "accepted") {
//         final fullname = data?['fullName'] ?? '';
//         final useremail = data?['email'] ?? '';
//         final userphone = data?['phone'] ?? '';

//         Nav.pushReplacement(
//           context,
//           OrphanageDashboardView(
//             fullname: fullname,
//             email: useremail,
//             phone: userphone,
//           ),
//         );
//       } else if (status == "Rejected") {
//         Nav.pushReplacement(context, const OrphanageRejectionView());
//       } else if (status == "AdminApprovalWaiting") {
//         Nav.pushReplacement(context, const OrphanagWaitingView());
//       }

//       return;
//     }

//     // Donor → go to donor page
//     // Nav.pushReplacement(context, const DonorTabBarView(username: username, useremail: useremail, userphone: userphone));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }
