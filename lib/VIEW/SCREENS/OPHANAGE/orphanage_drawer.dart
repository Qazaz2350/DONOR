// import 'package:donate/UTILIS/app_colors.dart';
// import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/Orphanage_View_Model.dart';
// import 'package:flutter/material.dart';

// class OrphanageDrawer extends StatefulWidget {
//   final OrphanageViewModel vm;

//   const OrphanageDrawer({Key? key, required this.vm}) : super(key: key);

//   @override
//   State<OrphanageDrawer> createState() => _OrphanageDrawerState();
// }

// class _OrphanageDrawerState extends State<OrphanageDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text(
//               widget.vm.nameController.text.isEmpty
//                   ? 'Orphanage'
//                   : widget.vm.nameController.text,
//             ),
//             accountEmail: Text(widget.vm.emailController.text),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: AppColors.primary,
//               child: const Icon(Icons.home, color: Colors.white),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.phone),
//             title: Text(widget.vm.phoneController.text),
//           ),
//           ListTile(
//             leading: const Icon(Icons.location_on),
//             title: Text(widget.vm.addressController.text),
//           ),
//           ListTile(
//             leading: Icon(
//               widget.vm.isVerified ? Icons.verified : Icons.pending,
//             ),
//             title: Text(
//               widget.vm.isVerified ? 'Verified' : 'Pending Verification',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
