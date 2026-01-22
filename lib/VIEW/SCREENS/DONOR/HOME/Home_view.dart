import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/VIEW/SCREENS/DONOR/HOME/app_drawer.dart';
import 'package:donate/VIEW/SCREENS/DONOR/HOME/donation_status_view.dart';
import 'package:donate/VIEW/SCREENS/DONOR/HOME/orphanage_detail_view.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
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
      create: (_) => DonorViewModel()
        ..fetchDonorStats()
        ..fetchAcceptedOrphanages(),
      child: Consumer<DonorViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: context.colors.background,
            drawer: AppDrawer(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------ Search Bar ------------------
                  Container(
                    padding: EdgeInsets.only(
                      top: 10.h,
                      left: 10.w,
                      right: 10.w,
                      bottom: 10.h,
                    ),
                    color: AppColors.blue,
                    height: 70,
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
                      ),
                    ),
                  ),

                  // ------------------ Welcome & Stats ------------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DonorStatsView(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Orphanages Near You',
                            style: TextStyle(
                              fontSize: FontSizes.f14,
                              color: context.colors.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        // const SizedBox(height: 12.h),
                        if (vm.isFetchingOrphanages)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.h),
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        else if (vm.orphanageError != null)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.h),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    size: 40.sp,
                                    color: Colors.red.withOpacity(0.6),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    vm.orphanageError!,
                                    style: TextStyle(
                                      fontSize: FontSizes.f12,
                                      color: context.colors.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (vm.acceptedOrphanages.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.h),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.location_off_outlined,
                                    size: 40.sp,
                                    color: context.colors.onSurface.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "No orphanages found nearby",
                                    style: TextStyle(
                                      fontSize: FontSizes.f12,
                                      color: context.colors.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 220.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(right: 15.w),
                              itemCount: vm.acceptedOrphanages.length,
                              itemBuilder: (context, index) {
                                final orphanage = vm.acceptedOrphanages[index];
                                final imageUrl =
                                    orphanage['orphanageImage'] ??
                                    'https://picsum.photos/200/120?random=$index';

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            OrphanageFoundationDetail(
                                              orphanage: orphanage,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 150.w,
                                    margin: EdgeInsets.only(right: 12.w),
                                    decoration: BoxDecoration(
                                      color: context.colors.surface,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Image with verified badge
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.r),
                                                topRight: Radius.circular(20.r),
                                              ),
                                              child: Image.network(
                                                imageUrl,
                                                height: 110.h,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        height: 110.h,
                                                        color: AppColors.primary
                                                            .withOpacity(0.1),
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported_outlined,
                                                          size: 32.sp,
                                                          color: context
                                                              .colors
                                                              .onSurface
                                                              .withOpacity(0.3),
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                            Positioned(
                                              top: 8.h,
                                              right: 8.w,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.secondary
                                                          .withOpacity(0.3),
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.verified_rounded,
                                                      color: AppColors.white,
                                                      size: 12.sp,
                                                    ),
                                                    SizedBox(width: 3.w),
                                                    Text(
                                                      'Verified',
                                                      style: TextStyle(
                                                        fontSize: FontSizes.f10,
                                                        color: AppColors.white,
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

                                        // Content section
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(12.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  orphanage['orphanagename'] ??
                                                      orphanage['name'] ??
                                                      'No Name',
                                                  style: TextStyle(
                                                    fontSize: FontSizes.f14,
                                                    fontWeight: FontWeight.bold,
                                                    color: context
                                                        .colors
                                                        .onSurface,
                                                    letterSpacing: 0.2,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4.h),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_rounded,
                                                      size: 12.sp,
                                                      color: AppColors.primary
                                                          .withOpacity(0.7),
                                                    ),
                                                    SizedBox(width: 3.w),
                                                    Expanded(
                                                      child: Text(
                                                        orphanage['orphanageaddress'] ??
                                                            orphanage['address'] ??
                                                            'Address not available',
                                                        style: TextStyle(
                                                          fontSize:
                                                              FontSizes.f10,
                                                          color: context
                                                              .colors
                                                              .onSurface
                                                              .withOpacity(0.6),
                                                          height: 1.3,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 30.h,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              OrphanageFoundationDetail(
                                                                orphanage:
                                                                    orphanage,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      foregroundColor:
                                                          AppColors.white,
                                                      elevation: 0,
                                                      padding: EdgeInsets.zero,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14.r,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "View Details",
                                                          style: TextStyle(
                                                            fontSize:
                                                                FontSizes.f12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: 0.2,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          size: 14.sp,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
