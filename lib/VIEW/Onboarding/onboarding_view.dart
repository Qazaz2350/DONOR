// ignore_for_file: deprecated_member_use

import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/UTILIS/app_fonts.dart';
import 'package:donate/VIEW/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Help the Needy",
      "body": "Help the needy by giving out items to them easily.",
      "image": "assets/lottie/Money Donation.json",
      "pageColor": AppColors.secondary,
    },
    {
      "title": "Easy Donations",
      "body": "Make your donations simple and reach those who need them most.",
      "image": "assets/lottie/Hand and Coin Donation Request.json",
      "pageColor": AppColors.primary,
    },
    {
      "title": "Make a Difference",
      "body":
          "Your small contribution can make a big impact in someone's life.",
      "image": "assets/lottie/Handshake.json",
      "pageColor": AppColors.secondary,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pages[_currentPage]["pageColor"],
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _buildPage(
                title: page["title"],
                body: page["body"],
                imagePath: page["image"],
                pageColor: page["pageColor"],
                pageIndex: index,
              );
            },
          ),
          // ---------------------- Skip Button ----------------------
          Positioned(
            top: 35.h,
            right: 16.w,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SignUpScreenView()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: FontSizes.f16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // ---------------------- Bottom Controls ----------------------
          Positioned(
            bottom: 30.h,
            left: 1.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dots
                Row(),
                // Next / Done Button
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const SignUpScreenView(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentPage == _pages.length - 2
                        ? AppColors.secondary
                        : AppColors.primary,
                    shape: _currentPage == _pages.length - 1
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          )
                        : const CircleBorder(),
                    padding: _currentPage == _pages.length - 1
                        ? EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h)
                        : EdgeInsets.all(12.sp),
                  ),
                  child: _currentPage == _pages.length - 1
                      ? Text(
                          "Done",
                          style: TextStyle(
                            fontSize: FontSizes.f16,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Icon(
                          Icons.arrow_forward,
                          color: AppColors.white,
                          size: 24.sp,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String body,
    required String imagePath,
    required Color pageColor,
    required int pageIndex, // add page index
  }) {
    return Container(
      color: pageColor,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
          Lottie.asset(
            imagePath,
            width: 300.w,
            height: 300.h,
            fit: BoxFit.contain,
            repeat: true,
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSizes.f28,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSizes.f16,
              color: AppColors.white,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          // Page Indicator below body text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentPage == index ? 30.w : 10.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    _currentPage == index ? 1 : 0.5,
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
