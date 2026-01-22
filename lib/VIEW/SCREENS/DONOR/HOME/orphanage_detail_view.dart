// // ignore_for_file: deprecated_member_use

// import 'package:donate/MODELS/SCREENS/DONOR/orphanage_model.dart';
// import 'package:donate/Utilis/extention.dart';
// import 'package:donate/Utilis/nav.dart';
// import 'package:donate/VIEW/SCREENS/DONOR/HOME/donation_page_view.dart';
// import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:donate/UTILIS/app_colors.dart';
// import 'package:donate/Utilis/app_fonts.dart';
// import 'package:intl/intl.dart';
// // import 'donorviewmodel.dart'; // Import your viewmodel

// class OrphanageDetailView extends StatelessWidget {
//   final OrphanageModel orphanage;

//   const OrphanageDetailView({Key? key, required this.orphanage})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final vm = DonorViewModel();

//     return Scaffold(
//       backgroundColor: context.colors.background,
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(context),
//           SliverToBoxAdapter(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeaderSection(context, vm),
//                 _buildContactSection(context),
//                 if (orphanage.needs.isNotEmpty) _buildNeedsSection(context, vm),
//                 if (orphanage.donationStock.isNotEmpty)
//                   _buildDonationStockSection(context, vm),
//                 _buildDescriptionSection(context),
//                 if (orphanage.images.length > 1) _buildImageGallery(context),
//                 if (orphanage.stories.isNotEmpty) _buildStoriesSection(context),
//                 if (orphanage.volunteeringEvents.isNotEmpty)
//                   _buildVolunteeringEventsSection(context),
//                 if (orphanage.donationHistory.isNotEmpty)
//                   _buildDonationHistorySection(context, vm),
//                 SizedBox(height: 100.h),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomBar(context),
//     );
//   }

//   Widget _buildSliverAppBar(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 300.h,
//       pinned: true,
//       backgroundColor: context.colors.surface,
//       iconTheme: IconThemeData(color: context.colors.onSurface),
//       leading: Container(
//         margin: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.5),
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       actions: [
//         Container(
//           margin: EdgeInsets.all(8.w),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.5),
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.share, color: Colors.white),
//             onPressed: () {},
//           ),
//         ),
//       ],
//       flexibleSpace: FlexibleSpaceBar(
//         background: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.network(
//               orphanage.images.isNotEmpty
//                   ? orphanage.images.first
//                   : 'https://picsum.photos/400/300',
//               fit: BoxFit.cover,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(BuildContext context, DonorViewModel vm) {
//     return Container(
//       margin: EdgeInsets.all(20.w),
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: context.colors.surface,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   orphanage.name,
//                   style: TextStyle(
//                     fontSize: FontSizes.f20,
//                     fontWeight: FontWeight.w800,
//                     color: context.colors.onSurface,
//                   ),
//                 ),
//               ),
//               if (orphanage.verified)
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 12.w,
//                     vertical: 6.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.secondary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.verified,
//                         color: AppColors.secondary,
//                         size: 16.sp,
//                       ),
//                       SizedBox(width: 4.w),
//                       Text(
//                         'Verified',
//                         style: TextStyle(
//                           color: AppColors.secondary,
//                           fontSize: FontSizes.f12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           Row(
//             children: [
//               Icon(Icons.location_on, size: 18.sp, color: AppColors.primary),
//               SizedBox(width: 8.w),
//               Expanded(
//                 child: Text(
//                   orphanage.address,
//                   style: TextStyle(
//                     fontSize: FontSizes.f14,
//                     color: context.colors.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (orphanage.latitude != null && orphanage.longitude != null) ...[
//             SizedBox(height: 8.h),
//             Row(
//               children: [
//                 Icon(
//                   Icons.my_location,
//                   size: 16.sp,
//                   color: context.colors.onSurface.withOpacity(0.6),
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   '${orphanage.latitude!.toStringAsFixed(4)}, ${orphanage.longitude!.toStringAsFixed(4)}',
//                   style: TextStyle(
//                     fontSize: FontSizes.f12,
//                     color: context.colors.onSurface.withOpacity(0.5),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildContactSection(BuildContext context) {
//     if (orphanage.contactEmail.isEmpty && orphanage.contactPhone.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.w),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Contact Information',
//             style: TextStyle(
//               fontSize: FontSizes.f16,
//               fontWeight: FontWeight.w700,
//               color: context.colors.onSurface,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           if (orphanage.contactEmail.isNotEmpty) ...[
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Icon(
//                     Icons.email_outlined,
//                     size: 20.sp,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Text(
//                     orphanage.contactEmail,
//                     style: TextStyle(
//                       fontSize: FontSizes.f14,
//                       color: context.colors.onSurface.withOpacity(0.8),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12.h),
//           ],
//           if (orphanage.contactPhone.isNotEmpty) ...[
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Icon(
//                     Icons.phone_outlined,
//                     size: 20.sp,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Text(
//                     orphanage.contactPhone,
//                     style: TextStyle(
//                       fontSize: FontSizes.f14,
//                       color: context.colors.onSurface.withOpacity(0.8),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildNeedsSection(BuildContext context, DonorViewModel vm) {
//     return Container(
//       margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Current Needs',
//             style: TextStyle(
//               fontSize: FontSizes.f16,
//               fontWeight: FontWeight.w700,
//               color: context.colors.onSurface,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           Wrap(
//             spacing: 8.w,
//             runSpacing: 8.h,
//             children: orphanage.needs.map((need) {
//               return Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       AppColors.primary.withOpacity(0.1),
//                       AppColors.secondary.withOpacity(0.1),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(12.r),
//                   border: Border.all(
//                     color: AppColors.primary.withOpacity(0.2),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       vm.getNeedIcon(need),
//                       size: 16.sp,
//                       color: AppColors.primary,
//                     ),
//                     SizedBox(width: 6.w),
//                     Text(
//                       need,
//                       style: TextStyle(
//                         fontSize: FontSizes.f14,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDonationStockSection(BuildContext context, DonorViewModel vm) {
//     return Container(
//       margin: EdgeInsets.all(20.w),
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: context.colors.surface,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.inventory_2_outlined,
//                 color: AppColors.primary,
//                 size: 24.sp,
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 'Current Stock',
//                 style: TextStyle(
//                   fontSize: FontSizes.f16,
//                   fontWeight: FontWeight.w700,
//                   color: context.colors.onSurface,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           ...orphanage.donationStock.entries.map((entry) {
//             return Container(
//               margin: EdgeInsets.only(bottom: 12.h),
//               padding: EdgeInsets.all(12.w),
//               decoration: BoxDecoration(
//                 color: context.colors.background,
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8.w),
//                     decoration: BoxDecoration(
//                       color: AppColors.secondary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Icon(
//                       vm.getNeedIcon(entry.key),
//                       size: 20.sp,
//                       color: AppColors.secondary,
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: Text(
//                       entry.key,
//                       style: TextStyle(
//                         fontSize: FontSizes.f14,
//                         fontWeight: FontWeight.w600,
//                         color: context.colors.onSurface,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                       vertical: 6.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.secondary,
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Text(
//                       '${entry.value}',
//                       style: TextStyle(
//                         fontSize: FontSizes.f14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescriptionSection(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.w),
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: context.colors.surface,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'About Orphanage',
//             style: TextStyle(
//               fontSize: FontSizes.f16,
//               fontWeight: FontWeight.w700,
//               color: context.colors.onSurface,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             orphanage.description,
//             style: TextStyle(
//               fontSize: FontSizes.f14,
//               color: context.colors.onSurface.withOpacity(0.8),
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageGallery(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 20.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Text(
//               'Photo Gallery',
//               style: TextStyle(
//                 fontSize: FontSizes.f16,
//                 fontWeight: FontWeight.w700,
//                 color: context.colors.onSurface,
//               ),
//             ),
//           ),
//           SizedBox(height: 12.h),
//           SizedBox(
//             height: 120.h,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               itemCount: orphanage.images.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   width: 160.w,
//                   margin: EdgeInsets.only(right: 12.w),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(16.r),
//                     child: Image.network(
//                       orphanage.images[index],
//                       fit: BoxFit.cover,
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

//   Widget _buildStoriesSection(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 20.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Text(
//               'Recent Stories',
//               style: TextStyle(
//                 fontSize: FontSizes.f16,
//                 fontWeight: FontWeight.w700,
//                 color: context.colors.onSurface,
//               ),
//             ),
//           ),
//           SizedBox(height: 12.h),
//           ...orphanage.stories.map((story) {
//             return Container(
//               margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: context.colors.surface,
//                 borderRadius: BorderRadius.circular(16.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(8.w),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         child: Icon(
//                           Icons.auto_stories,
//                           size: 20.sp,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               story.title,
//                               style: TextStyle(
//                                 fontSize: FontSizes.f14,
//                                 fontWeight: FontWeight.w700,
//                                 color: context.colors.onSurface,
//                               ),
//                             ),
//                             SizedBox(height: 4.h),
//                             Text(
//                               DateFormat('MMM dd, yyyy').format(story.date),
//                               style: TextStyle(
//                                 fontSize: FontSizes.f12,
//                                 color: context.colors.onSurface.withOpacity(
//                                   0.5,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12.h),
//                   Text(
//                     story.content,
//                     style: TextStyle(
//                       fontSize: FontSizes.f14,
//                       color: context.colors.onSurface.withOpacity(0.8),
//                       height: 1.5,
//                     ),
//                   ),
//                   if (story.images.isNotEmpty) ...[
//                     SizedBox(height: 12.h),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12.r),
//                       child: Image.network(
//                         story.images.first,
//                         height: 150.h,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildVolunteeringEventsSection(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 20.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Text(
//               'Volunteering Events',
//               style: TextStyle(
//                 fontSize: FontSizes.f16,
//                 fontWeight: FontWeight.w700,
//                 color: context.colors.onSurface,
//               ),
//             ),
//           ),
//           SizedBox(height: 12.h),
//           ...orphanage.volunteeringEvents.map((event) {
//             final spotsLeft = event.capacity - event.registered;
//             final isAlmostFull = spotsLeft <= 5;

//             return Container(
//               margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: context.colors.surface,
//                 borderRadius: BorderRadius.circular(16.r),
//                 border: Border.all(
//                   color: AppColors.secondary.withOpacity(0.2),
//                   width: 2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.secondary.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(10.w),
//                         decoration: BoxDecoration(
//                           color: AppColors.secondary.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                         child: Icon(
//                           Icons.volunteer_activism,
//                           size: 24.sp,
//                           color: AppColors.secondary,
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               event.title,
//                               style: TextStyle(
//                                 fontSize: FontSizes.f16,
//                                 fontWeight: FontWeight.w700,
//                                 color: context.colors.onSurface,
//                               ),
//                             ),
//                             SizedBox(height: 4.h),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.calendar_today,
//                                   size: 12.sp,
//                                   color: context.colors.onSurface.withOpacity(
//                                     0.6,
//                                   ),
//                                 ),
//                                 SizedBox(width: 4.w),
//                                 Text(
//                                   DateFormat('MMM dd, yyyy').format(event.date),
//                                   style: TextStyle(
//                                     fontSize: FontSizes.f12,
//                                     color: context.colors.onSurface.withOpacity(
//                                       0.6,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12.h),
//                   Text(
//                     event.description,
//                     style: TextStyle(
//                       fontSize: FontSizes.f14,
//                       color: context.colors.onSurface.withOpacity(0.8),
//                       height: 1.5,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 8.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isAlmostFull
//                                 ? Colors.orange.withOpacity(0.1)
//                                 : Colors.green.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.people,
//                                 size: 16.sp,
//                                 color: isAlmostFull
//                                     ? Colors.orange
//                                     : Colors.green,
//                               ),
//                               SizedBox(width: 6.w),
//                               Text(
//                                 '$spotsLeft spots left',
//                                 style: TextStyle(
//                                   fontSize: FontSizes.f12,
//                                   fontWeight: FontWeight.w600,
//                                   color: isAlmostFull
//                                       ? Colors.orange
//                                       : Colors.green,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Text(
//                         '${event.registered}/${event.capacity} registered',
//                         style: TextStyle(
//                           fontSize: FontSizes.f12,
//                           color: context.colors.onSurface.withOpacity(0.6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDonationHistorySection(BuildContext context, DonorViewModel vm) {
//     return Container(
//       margin: EdgeInsets.only(top: 20.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Text(
//               'Recent Donations',
//               style: TextStyle(
//                 fontSize: FontSizes.f16,
//                 fontWeight: FontWeight.w700,
//                 color: context.colors.onSurface,
//               ),
//             ),
//           ),
//           SizedBox(height: 12.h),
//           ...orphanage.donationHistory.take(5).map((donation) {
//             return Container(
//               margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
//               padding: EdgeInsets.all(12.w),
//               decoration: BoxDecoration(
//                 color: context.colors.surface,
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(
//                   color: context.colors.onSurface.withOpacity(0.1),
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8.w),
//                     decoration: BoxDecoration(
//                       color: vm
//                           .getDonationColor(donation.type)
//                           .withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Icon(
//                       vm.getDonationIcon(donation.type),
//                       size: 20.sp,
//                       color: vm.getDonationColor(donation.type),
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           donation.type,
//                           style: TextStyle(
//                             fontSize: FontSizes.f14,
//                             fontWeight: FontWeight.w600,
//                             color: context.colors.onSurface,
//                           ),
//                         ),
//                         SizedBox(height: 2.h),
//                         Text(
//                           donation.amount != null
//                               ? 'PKR ${donation.amount!.toStringAsFixed(0)}'
//                               : '${donation.quantity} items',
//                           style: TextStyle(
//                             fontSize: FontSizes.f12,
//                             color: context.colors.onSurface.withOpacity(0.6),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     DateFormat('MMM dd').format(donation.date),
//                     style: TextStyle(
//                       fontSize: FontSizes.f12,
//                       color: context.colors.onSurface.withOpacity(0.5),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomBar(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: context.colors.surface,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: SizedBox(
//                 height: 50.h,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.secondary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     elevation: 0,
//                   ),
//                   onPressed: () {
//                     Nav.push(
//                       context,
//                       DonationPageView(orphanage_name: orphanage.name),
//                     );
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.favorite, color: AppColors.white, size: 20.sp),
//                       SizedBox(width: 8.w),
//                       Text(
//                         'Donate Now',
//                         style: TextStyle(
//                           fontSize: FontSizes.f16,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Container(
//               height: 50.h,
//               width: 50.h,
//               decoration: BoxDecoration(
//                 color: AppColors.primary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: IconButton(
//                 icon: Icon(
//                   Icons.volunteer_activism,
//                   color: AppColors.primary,
//                   size: 24.sp,
//                 ),
//                 onPressed: () {},
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
