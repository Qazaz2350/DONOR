import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/UTILIS/app_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 35.r,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.person,
                    size: 40.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'QAZAZ AHSAN',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: FontSizes.f20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: AppColors.primary),
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.primary),
            title: Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.help, color: AppColors.primary),
            title: Text('Help'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.primary),
            title: Text('Logout'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
