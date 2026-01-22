// import 'package:donate/Utilis/extention.dart';
// import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
// import 'package:donate/Utilis/app_fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// class DonationHistoryPage extends StatefulWidget {
//   final DonorViewModel vm;

//   const DonationHistoryPage({Key? key, required this.vm}) : super(key: key);

//   @override
//   State<DonationHistoryPage> createState() => _DonationHistoryPageState();
// }

// class _DonationHistoryPageState extends State<DonationHistoryPage> {
//   bool _sortAscending = true;

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Shipped":
//         return Colors.blue;
//       case "Delivered":
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   List _getSortedDonations() {
//     final donations = List.from(widget.vm.donationHistory);
//     donations.sort((a, b) {
//       if (_sortAscending) {
//         return a.orphanageName.toLowerCase().compareTo(
//           b.orphanageName.toLowerCase(),
//         );
//       } else {
//         return b.orphanageName.toLowerCase().compareTo(
//           a.orphanageName.toLowerCase(),
//         );
//       }
//     });
//     return donations;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final donations = _getSortedDonations();

//     return Scaffold(
//       backgroundColor: context.colors.background,

//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 16.0,
//             ),
//             child: Text(
//               " History",
//               style: TextStyle(
//                 color: context.colors.onSurface,
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               itemCount: donations.length,
//               itemBuilder: (context, index) {
//                 final donation = donations[index];
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 12.h),
//                   decoration: BoxDecoration(
//                     color: context.colors.surface,
//                     borderRadius: BorderRadius.circular(16.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Row(
//                       children: [
//                         // Icon
//                         Container(
//                           padding: EdgeInsets.all(12.w),
//                           decoration: BoxDecoration(
//                             color: _getStatusColor(
//                               donation.status,
//                             ).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           child: Icon(
//                             widget.vm.getDonationIcon(donation.type),
//                             color: _getStatusColor(donation.status),
//                             size: 24.sp,
//                           ),
//                         ),
//                         SizedBox(width: 16.w),
//                         // Content
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Type and Amount
//                               Text(
//                                 donation.type == "Money"
//                                     ? "${donation.type}: \$${donation.amount?.toStringAsFixed(2)}"
//                                     : donation.type,
//                                 style: TextStyle(
//                                   fontSize: FontSizes.f16,
//                                   fontWeight: FontWeight.w700,
//                                   color: context.colors.onSurface,
//                                 ),
//                               ),
//                               SizedBox(height: 6.h),
//                               // Orphanage Name
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.home_outlined,
//                                     size: 14.sp,
//                                     color: context.colors.onSurface.withOpacity(
//                                       0.6,
//                                     ),
//                                   ),
//                                   SizedBox(width: 4.w),
//                                   Expanded(
//                                     child: Text(
//                                       donation.orphanageName,
//                                       style: TextStyle(
//                                         fontSize: FontSizes.f14,
//                                         color: context.colors.onSurface
//                                             .withOpacity(0.7),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 4.h),
//                               // Date
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.calendar_today,
//                                     size: 14.sp,
//                                     color: context.colors.onSurface.withOpacity(
//                                       0.6,
//                                     ),
//                                   ),
//                                   SizedBox(width: 4.w),
//                                   Text(
//                                     DateFormat(
//                                       'dd MMM yyyy',
//                                     ).format(donation.date),
//                                     style: TextStyle(
//                                       fontSize: FontSizes.f12,
//                                       color: context.colors.onSurface
//                                           .withOpacity(0.6),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         // Status Badge
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 6.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: _getStatusColor(
//                               donation.status,
//                             ).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8.r),
//                             border: Border.all(
//                               color: _getStatusColor(donation.status),
//                               width: 1,
//                             ),
//                           ),
//                           child: Text(
//                             donation.status,
//                             style: TextStyle(
//                               fontSize: FontSizes.f12,
//                               color: _getStatusColor(donation.status),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
