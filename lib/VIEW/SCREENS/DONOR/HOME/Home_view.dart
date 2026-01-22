import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/VIEW/SCREENS/DONOR/HOME/app_drawer.dart';
import 'package:donate/VIEW/SCREENS/DONOR/HOME/donation_status_view.dart';

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

    // ✅ Fetch orphanages once
    // final vm = DonorViewModel();
    // vm.fetchOffdOrphanages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorViewModel()..fetchOffdOrphanages(),
      child: Consumer<DonorViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: context.colors.background,
            drawer: AppDrawer(),

            body: Column(
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

                      // ------------------ Orphanage Cards ------------------
                      vm.isOffdLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : vm.offdOrphanages.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: Text('No orphanages found')),
                            )
                          : SizedBox(
                              height: 180.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: vm.offdOrphanages.length,
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                itemBuilder: (context, index) {
                                  final orphanage = vm.offdOrphanages[index];

                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 3,
                                    child: Container(
                                      width: 250.w,
                                      padding: EdgeInsets.all(10.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            orphanage['offd_fullname'] ??
                                                'No Name',
                                          ),

                                          // Status & Address
                                          Text(
                                            'Status: ${orphanage['offd_status'] ?? 'pending'}',
                                            style: TextStyle(
                                              fontSize: FontSizes.f12,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Address: ${orphanage['offd_address'] ?? 'N/A'}',
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
          );
        },
      ),
    );
  }
}
