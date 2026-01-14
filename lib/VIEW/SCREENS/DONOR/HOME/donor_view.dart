import 'package:donate/MODELS/SCREENS/DONOR/orphanage_model.dart';
import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/VIEW/SCREENS/DONOR/HOME/orphanage_detail_view.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DonorView extends StatefulWidget {
  const DonorView({Key? key}) : super(key: key);

  @override
  State<DonorView> createState() => _DonorViewState();
}

class _DonorViewState extends State<DonorView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorViewModel(),
      child: Consumer<DonorViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: context.colors.background,

            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        style: TextStyle(
                          fontSize: FontSizes.f14,
                          color: context.colors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search orphanages...',
                          hintStyle: TextStyle(
                            fontSize: FontSizes.f14,
                            color: context.colors.onSurface.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.primary,
                            size: 24.sp,
                          ),
                          suffixIcon: Icon(
                            Icons.tune_rounded,
                            color: context.colors.onSurface.withOpacity(0.6),
                            size: 22.sp,
                          ),
                          filled: true,
                          fillColor: context.colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: context.colors.onSurface.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                        ),
                      ),
                    ),

                    // ------------------ WELCOME CARD ------------------
                    Text(
                      'Orphanages Near You',
                      style: TextStyle(
                        fontSize: FontSizes.f14,
                        color: context.colors.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ------------------ ORPHANAGES GRID ------------------
                    SizedBox(
                      height: 210.h, // adjust height to fit your card
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dummyOrphanages.length,
                        // padding: EdgeInsets.symmetric(horizontal: 12.w),
                        itemBuilder: (context, index) {
                          final orphanage = dummyOrphanages[index];
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrphanageDetailView(
                                      orphanage: orphanage,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 130
                                    .w, // roughly half of your previous grid width
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(
                                        0.08,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image + gradient + verified
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20.r),
                                          ),
                                          child: Image.network(
                                            orphanage.images.isNotEmpty
                                                ? orphanage.images[0]
                                                : 'https://picsum.photos/200/300',
                                            height: 120.h,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.r),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.3),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (orphanage.verified)
                                          Positioned(
                                            top: 8.h,
                                            right: 8.w,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6.w,
                                                vertical: 3.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.verified,
                                                    color: AppColors.secondary,
                                                    size: 12.sp,
                                                  ),
                                                  SizedBox(width: 3.w),
                                                  Text(
                                                    'Verified',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.secondary,
                                                      fontSize: FontSizes.f10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    // Content
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 6,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              orphanage.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: FontSizes.f12,
                                                fontWeight: FontWeight.w700,
                                                color: context.colors.onSurface,
                                                height: 1.3,
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  size: 12.sp,
                                                  color: AppColors.primary
                                                      .withOpacity(0.6),
                                                ),
                                                SizedBox(width: 3.w),
                                                Expanded(
                                                  child: Text(
                                                    orphanage.address,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: FontSizes.f10,
                                                      color: context
                                                          .colors
                                                          .onSurface
                                                          .withOpacity(0.6),
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 6.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'View Details',
                                                    style: TextStyle(
                                                      fontSize: FontSizes.f10,
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 8.sp,
                                                    color: AppColors.primary,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
