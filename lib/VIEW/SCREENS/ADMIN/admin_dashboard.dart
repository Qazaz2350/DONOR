import 'package:donate/Utilis/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<String> _menuItems = [
    'Dashboard',
    'Users',
    'Donations',
    'Clothes',
    'Cash',
    'Challenges',
    'Reminders',
    'Analytics',
    'Settings',
    'Logout',
  ];

  final List<IconData> _menuIcons = [
    Icons.dashboard_rounded,
    Icons.people_rounded,
    Icons.volunteer_activism_rounded,
    Icons.checkroom_rounded,
    Icons.attach_money_rounded,
    Icons.emoji_events_rounded,
    Icons.access_time_rounded,
    Icons.analytics_rounded,
    Icons.settings_rounded,
    Icons.logout_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF5F7FA),
          drawer: _buildDrawer(),
          body: Row(
            children: [
              // Sidebar (for larger screens)
              if (MediaQuery.of(context).size.width >= 800) _buildDrawer(),
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildMainContent()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width < 800)
            Container(
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: IconButton(
                icon: Icon(Icons.menu_rounded, color: AppColors.primary),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
          Text(
            _menuItems[_selectedIndex],
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              color: AppColors.black,
              onPressed: () {},
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.white,
              child: Text(
                "A",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// DRAWER / SIDEBAR
  Widget _buildDrawer() {
    return Container(
      width: 250.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 140.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.volunteer_activism_rounded,
                    color: AppColors.primary,
                    size: 30.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'DoNation',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                bool selected = _selectedIndex == index;
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary.withOpacity(0.3)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    leading: Icon(
                      _menuIcons[index],
                      color: selected ? AppColors.primary : Colors.grey[600],
                      size: 22.sp,
                    ),
                    title: Text(
                      _menuItems[index],
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: selected ? AppColors.primary : Colors.grey[800],
                        fontSize: 14.sp,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      if (MediaQuery.of(context).size.width < 800) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// MAIN CONTENT
  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardScreen();
      case 1:
        return _buildUsersScreen();
      case 2:
        return _buildDonationsScreen();
      default:
        return _buildComingSoonScreen();
    }
  }

  /// DASHBOARD SCREEN
  Widget _buildDashboardScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: [
              _buildStatCard(
                "Total Users",
                "1,250",
                Icons.people_rounded,
                "+5%",
                AppColors.primary,
              ),
              _buildStatCard(
                "Total Donations",
                "5,430",
                Icons.volunteer_activism_rounded,
                "+8%",
                AppColors.secondary,
              ),
              _buildStatCard(
                "Clothes Donated",
                "3,210",
                Icons.checkroom_rounded,
                "+3%",
                Colors.orange,
              ),
              _buildStatCard(
                "Cash Donated",
                "\$12,540",
                Icons.attach_money_rounded,
                "+10%",
                Colors.green,
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Recent Activities",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Column(
                  children: List.generate(
                    5,
                    (index) => _buildActivityItem(
                      "User${index + 1} donated clothes",
                      "2 mins ago",
                      index,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flash_on_rounded,
                      color: AppColors.secondary,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    _buildActionButton(
                      Icons.person_add_rounded,
                      "Add User",
                      AppColors.primary,
                    ),
                    _buildActionButton(
                      Icons.emoji_events_rounded,
                      "Create Challenge",
                      AppColors.secondary,
                    ),
                    _buildActionButton(
                      Icons.notifications_active_rounded,
                      "Send Notification",
                      Colors.orange,
                    ),
                    _buildActionButton(
                      Icons.assessment_rounded,
                      "Generate Report",
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// USERS SCREEN
  Widget _buildUsersScreen() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_rounded),
                label: const Text("Add User"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                  headingRowHeight: 56.h,
                  dataRowHeight: 64.h,
                  columns: [
                    DataColumn(
                      label: Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Donations",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Actions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                  rows: List.generate(
                    10,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text("User $index")),
                        DataCell(Text("user$index@example.com")),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              "${index * 3}",
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (index % 2 == 0 ? Colors.green : Colors.red)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              index % 2 == 0 ? "Active" : "Inactive",
                              style: TextStyle(
                                color: index % 2 == 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit_rounded,
                                    size: 18.sp,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    size: 18.sp,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// DONATIONS SCREEN
  Widget _buildDonationsScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Wrap(
        spacing: 20.w,
        runSpacing: 20.h,
        children: [
          _buildDonationCard(
            "Clothes Donations",
            "3,210",
            Icons.checkroom_rounded,
            AppColors.primary,
          ),
          _buildDonationCard(
            "Cash Donations",
            "\$12,540",
            Icons.attach_money_rounded,
            Colors.green,
          ),
          _buildDonationCard(
            "Total Items",
            "8,750",
            Icons.inventory_rounded,
            AppColors.secondary,
          ),
        ],
      ),
    );
  }

  /// COMING SOON SCREEN
  Widget _buildComingSoonScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.construction_rounded,
              size: 80.sp,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Coming Soon",
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "This feature is under development",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// WIDGETS
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    String change,
    Color color,
  ) {
    return Container(
      width: 180.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 28.sp, color: color),
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              change,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String description, String time, int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      Colors.orange,
      Colors.green,
      Colors.purple,
    ];
    final icons = [
      Icons.checkroom_rounded,
      Icons.attach_money_rounded,
      Icons.volunteer_activism_rounded,
      Icons.emoji_events_rounded,
      Icons.favorite_rounded,
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: colors[index % colors.length].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icons[index % icons.length],
              size: 20.sp,
              color: colors[index % colors.length],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20.sp),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildDonationCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, size: 40.sp, color: color),
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
