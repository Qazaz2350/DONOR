import 'package:donate/MODELS/SCREENS/DONOR/orphanage_model.dart';
import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/VIEW/SCREENS/DONOR/app_drawer.dart';
import 'package:donate/VIEW/SCREENS/DONOR/orphanage_detail_view.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SenderView extends StatefulWidget {
  const SenderView({Key? key}) : super(key: key);

  @override
  State<SenderView> createState() => _SenderViewState();
}

class _SenderViewState extends State<SenderView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Donorviewmodel(),
      child: Consumer<Donorviewmodel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.white,
            drawer: const AppDrawer(),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              child: Icon(
                                Icons.menu,
                                size: 28.sp,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              size: 28.sp,
                              color: AppColors.black,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildHomeTabContent(vm),
                        _buildCenterTab('Clothes Tab'),
                        _buildCenterTab('Cash Tab'),
                        _buildCenterTab('Challenges Tab'),
                        _buildCenterTab('Reminders Tab'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        },
      ),
    );
  }

  // ------------------ Home Tab Content ------------------
  // import 'models/orphanage_dummy.dart'; // make sure you import your dummy data

  Widget _buildHomeTabContent(Donorviewmodel vm) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vm.getGreeting(),
                    style: TextStyle(
                      fontSize: FontSizes.f14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'QAZAZ AHSAN',
                    style: TextStyle(
                      fontSize: FontSizes.f20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 23.r,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 24.sp, color: Colors.grey[600]),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          Text(
            'Click here to expand',
            style: TextStyle(fontSize: FontSizes.f14, color: Colors.grey[600]),
          ),
          SizedBox(height: 12.h),

          GestureDetector(
            onTap: vm.toggleWelcome,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Welcome to DoNation',
                          style: TextStyle(
                            fontSize: FontSizes.f20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Icon(
                          vm.isWelcomeExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Your journey to making a difference starts here! Explore our app to find various ways to contribute, stay updated with challenges, and set reminders for your donations. Together, we can create a better world, one act of kindness at a time.",
                      maxLines: vm.isWelcomeExpanded ? null : 2,
                      overflow: vm.isWelcomeExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: FontSizes.f12,
                        color: AppColors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // ------------------ Orphanages Horizontal List ------------------
          GridView.builder(
            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.symmetric(horizontal: 20.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 21.h,

              childAspectRatio: 0.75, // Adjust this for card height
            ),
            itemCount: dummyOrphanages.length,
            itemBuilder: (context, index) {
              final orphanage = dummyOrphanages[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrphanageDetailView(orphanage: orphanage),
                    ),
                  );
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
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
                      // Image with gradient overlay
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
                          // Gradient overlay
                          Container(
                            // height: 50.h,
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
                          // Verified badge
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
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
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
                                        color: AppColors.secondary,
                                        fontSize: FontSizes.f10,
                                        fontWeight: FontWeight.w600,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orphanage.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: FontSizes.f12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 12.sp,
                                    color: AppColors.primary.withOpacity(0.6),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      orphanage.address,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: FontSizes.f10,
                                        color: Colors.grey[600],
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // View Details button
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View Details',
                                      style: TextStyle(
                                        fontSize: FontSizes.f10,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
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
              );
            },
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildCenterTab(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: FontSizes.f20, color: AppColors.black),
    ),
  );

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.secondary,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.transparent,

        labelStyle: TextStyle(
          fontSize: FontSizes.f12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: FontSizes.f12),

        tabs: [
          Tab(
            icon: Icon(Icons.home, size: 24.sp),
            text: 'Home',
          ),
          Tab(
            icon: ImageIcon(
              AssetImage('assets/icons/handshake.png'),
              size: 24.sp,
            ),
            text: 'Donations ',
          ),
          Tab(
            icon: ImageIcon(AssetImage('assets/icons/event.png'), size: 24.sp),
            text: 'Events',
          ),
          Tab(
            icon: ImageIcon(AssetImage('assets/icons/story.png'), size: 24.sp),
            text: 'Story Feed',
          ),
        ],
      ),
    );
  }
}
