import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/VIEW/SCREENS/DONOR/DONATIONS/donations_view.dart';
import 'package:donate/VIEW/SCREENS/DONOR/HOME/Home_view.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DonorTabBarView extends StatefulWidget {
  const DonorTabBarView({Key? key}) : super(key: key);

  @override
  State<DonorTabBarView> createState() => _DonorTabBarViewState();
}

class _DonorTabBarViewState extends State<DonorTabBarView>
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
            // ---------------- AppBar ----------------
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.blue,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.menu,
                          size: 32.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 138),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          vm.getGreeting(),
                          style: TextStyle(
                            fontSize: FontSizes.f12,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'QAZAZ AHSAN',
                          style: TextStyle(
                            fontSize: FontSizes.f16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        size: 28.sp,
                        color: AppColors.white,
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

            // ---------------- Body ----------------
            body: Column(
              children: [
                // ---------------- TabBarView ----------------
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // home
                      HomeView(),
                      // donations
                      DonationHistoryPage(vm: vm),
                      // WishCard(),
                      Center(
                        child: Text(
                          'Story Feed Screen',
                          style: TextStyle(
                            fontSize: FontSizes.f16,
                            fontWeight: FontWeight.bold,
                            color: context.colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- Bottom TabBar ----------------
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
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
                    unselectedLabelColor: context.colors.onSurface.withOpacity(
                      0.6,
                    ),
                    indicatorColor: Colors.transparent,
                    labelStyle: TextStyle(
                      fontSize: FontSizes.f12,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(fontSize: FontSizes.f12),
                    tabs: [
                      Tab(
                        icon: ImageIcon(
                          AssetImage('assets/icons/home.png'),
                          size: 24.sp,
                        ),
                        text: 'Home',
                      ),
                      Tab(
                        icon: ImageIcon(
                          AssetImage('assets/icons/handshake.png'),
                          size: 24.sp,
                        ),
                        text: 'Donations',
                      ),
                      Tab(
                        icon: ImageIcon(
                          AssetImage('assets/icons/event.png'),
                          size: 24.sp,
                        ),
                        text: 'Events',
                      ),
                      Tab(
                        icon: ImageIcon(
                          AssetImage('assets/icons/story.png'),
                          size: 24.sp,
                        ),
                        text: 'Story Feed',
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
