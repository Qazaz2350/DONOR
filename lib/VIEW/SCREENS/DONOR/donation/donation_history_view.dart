import 'package:donate/Utilis/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
// import 'package:donate/Utilis/app_theme.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;
import 'dart:ui';

class DonationHistoryView extends StatefulWidget {
  const DonationHistoryView({super.key});

  @override
  State<DonationHistoryView> createState() => _DonationHistoryViewState();
}

class _DonationHistoryViewState extends State<DonationHistoryView>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
  late AnimationController _xpBarController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;

  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _xpBarAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    // Confetti
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Header animation
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _headerSlideAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    );
    _headerFadeAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    // List animation
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // XP Bar animation
    _xpBarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _xpBarAnimation = CurvedAnimation(
      parent: _xpBarController,
      curve: Curves.easeInOutCubic,
    );

    // Pulse animation for badges
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Floating animation
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    _floatingAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Start animations
    Future.delayed(const Duration(milliseconds: 200), () {
      _headerAnimationController.forward();
      _xpBarController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    _xpBarController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _triggerConfetti() {
    _confettiController.play();
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => DonorViewModel()
        ..fetchUserDonations()
        ..checkMicroMilestones(),
      child: Consumer<DonorViewModel>(
        builder: (context, donorVM, _) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: context.colors.background,

            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  _buildAnimatedBackground(isDark),
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: 8.h),
                        _buildBadgeHeader(donorVM, isDark),
                        SizedBox(height: 12.h),
                        Expanded(child: _buildDonationList(donorVM, isDark)),
                      ],
                    ),
                  ),
                  // Confetti overlay
                  _buildConfettiOverlay(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===== Simple Background - Theme Based =====
  Widget _buildAnimatedBackground(bool isDark) {
    return Container(color: isDark ? AppColors.black : AppColors.white);
  }

  // ===== Enhanced Badge Header with Animations =====
  Widget _buildBadgeHeader(DonorViewModel donorVM, bool isDark) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(_headerSlideAnimation),
      child: FadeTransition(
        opacity: _headerFadeAnimation,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.blue.withOpacity(0.15)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark
                      ? AppColors.white.withOpacity(0.1)
                      : AppColors.white.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Rank & XP Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRankBadge(donorVM.rank),
                      _buildGlowingXP(donorVM.xp),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Animated XP Progress Bar
                  _buildAnimatedXPBar(donorVM, isDark),
                  SizedBox(height: 12.h),

                  // Animated Badges with 3D effect
                  _buildAnimatedBadges(donorVM, isDark),
                  SizedBox(height: 10.h),

                  // Weekly Streak with flame animation
                  _buildAnimatedStreak(donorVM, isDark),
                ],
              ),
            ),

            // Confetti Widget
            Positioned.fill(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 30,
                gravity: 0.3,
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.blue,
                  AppColors.primary.withOpacity(0.7),
                  AppColors.secondary.withOpacity(0.7),
                  AppColors.blue.withOpacity(0.7),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Get Rank Color =====
  Color _getRankColor(String rank) {
    switch (rank.toLowerCase()) {
      case 'bronze':
        return AppColors.primary; // Teal/turquoise for bronze
      case 'silver':
        return AppColors.blue; // Dark blue for silver
      case 'gold':
        return AppColors.primary; // Royal blue for gold
      default:
        return AppColors.secondary; // Default to secondary
    }
  }

  // ===== Rank Badge Widget =====
  Widget _buildRankBadge(String rank) {
    final rankColor = _getRankColor(rank);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: rankColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: rankColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.military_tech, color: rankColor, size: 16.sp),
          SizedBox(width: 4.w),
          Text(
            rank.toUpperCase(),
            style: TextStyle(
              fontSize: FontSizes.f12,
              fontWeight: FontWeight.w800,
              color: rankColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ===== Gradient Text Widget with AppColors =====
  Widget _buildGradientText(
    String text, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [AppColors.primary, AppColors.secondary, AppColors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: AppColors.white,
        ),
      ),
    );
  }

  // ===== XP Badge with AppColors =====
  Widget _buildGlowingXP(int xp) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stars, color: AppColors.white, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              '$xp XP',
              style: TextStyle(
                fontSize: FontSizes.f12,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Animated XP Progress Bar =====
  Widget _buildAnimatedXPBar(DonorViewModel donorVM, bool isDark) {
    final progress = (donorVM.xp.clamp(0, 500) / 500);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level Progress',
              style: TextStyle(
                fontSize: FontSizes.f10,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: FontSizes.f10,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Stack(
          children: [
            // Background track
            Container(
              height: 12.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            // Animated filled portion
            AnimatedBuilder(
              animation: _xpBarAnimation,
              builder: (context, child) {
                return Container(
                  height: 12.h,
                  width: progress * _xpBarAnimation.value * 1.sw,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 6,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Stack(
                      children: [
                        // Shimmer effect
                        Positioned.fill(child: _buildShimmerEffect()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // ===== Shimmer Effect for XP Bar =====
  Widget _buildShimmerEffect() {
    return AnimatedBuilder(
      animation: _xpBarController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_xpBarController.value * 300 - 150, 0),
          child: Container(
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.white.withOpacity(0.0),
                  AppColors.white.withOpacity(0.4),
                  AppColors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===== Animated Badges =====
  Widget _buildAnimatedBadges(DonorViewModel donorVM, bool isDark) {
    if (donorVM.badges.isEmpty) {
      return Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.grey[100],
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              'Complete donations to earn badges!',
              style: TextStyle(
                fontSize: FontSizes.f10,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(donorVM.badges.length, (index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: GestureDetector(
                onTap: () {
                  _triggerConfetti();
                },
                child: AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          donorVM.badges[index],
                          style: TextStyle(
                            fontSize: FontSizes.f10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ===== Animated Streak =====
  Widget _buildAnimatedStreak(DonorViewModel donorVM, bool isDark) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: Container(
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Icon(
                      Icons.local_fire_department,
                      color: AppColors.secondary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${donorVM.weeklyStreak} Day Streak 🔥',
                    style: TextStyle(
                      fontSize: FontSizes.f12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===== Enhanced Donation List =====
  Widget _buildDonationList(DonorViewModel donorVM, bool isDark) {
    if (donorVM.isFetchingDonations) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoadingAnimation(),
            SizedBox(height: 12.h),
            Text(
              'Loading your impact...',
              style: TextStyle(
                fontSize: FontSizes.f12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (donorVM.userDonations.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: donorVM.userDonations.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 80)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildDonationCard(donorVM.userDonations[index], isDark),
              ),
            );
          },
        );
      },
    );
  }

  // ===== COMPACT Donation Card with Theme Colors =====
  Widget _buildDonationCard(donation, bool isDark) {
    final category = donation.category;
    final orphanageName = donation.foundationName;
    final timestamp = donation.timestamp;

    final amountText = donation.amount != null
        ? 'Rs ${donation.amount!.toStringAsFixed(0)}'
        : 'Qty ${donation.quantity ?? 0}';

    // Category-based color scheme
    final cardGradient = _getCardGradient(category);
    final iconData = _getCategoryIcon(category);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
          },
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: cardGradient[0],
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animated Icon - Compact
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: EdgeInsets.all(7.w),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.08),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          iconData,
                          size: 16.sp,
                          color: cardGradient[0],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 8.w),

                // Content - Compact
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        orphanageName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: FontSizes.f12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          shadows: [
                            Shadow(
                              color: AppColors.black.withOpacity(0.15),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Text(
                              category ?? '',
                              style: TextStyle(
                                fontSize: FontSizes.f10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: FontSizes.f10,
                              color: AppColors.white.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            amountText,
                            style: TextStyle(
                              fontSize: FontSizes.f10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white.withOpacity(0.95),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 10.sp,
                            color: AppColors.white.withOpacity(0.6),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            DateFormat('dd MMM yyyy').format(timestamp),
                            style: TextStyle(
                              fontSize: FontSizes.f10,
                              color: AppColors.white.withOpacity(0.75),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Achievement Badge - Compact
                if (donation.amount != null || donation.quantity != null)
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.35),
                            blurRadius: 6,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 14.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== Category-based Colors using AppColors only =====
  List<Color> _getCardGradient(String? category) {
    switch (category?.toLowerCase()) {
      case 'money':
        return [AppColors.secondary]; // Teal for money
      case 'food':
        return [AppColors.primary]; // Royal blue for food
      case 'toys':
        return [AppColors.blue]; // Dark blue for toys
      case 'education':
        return [AppColors.primary]; // Royal blue for education
      case 'clothes':
        return [AppColors.secondary]; // Teal for clothes
      default:
        return [AppColors.primary]; // Default primary
    }
  }

  // ===== Category Icons =====
  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'money':
        return Icons.attach_money_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'toys':
        return Icons.toys_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'clothes':
        return Icons.checkroom_rounded;
      default:
        return Icons.volunteer_activism_rounded;
    }
  }

  // ===== Empty State =====
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: EdgeInsets.all(35.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.volunteer_activism_outlined,
                    size: 60.sp,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
          Text(
            'Start Your Journey',
            style: TextStyle(
              fontSize: FontSizes.f20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.grey[200] : Colors.grey[800],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Make your first donation to begin\ncollecting badges and XP!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSizes.f12,
              color: isDark ? Colors.grey[500] : Colors.grey[600],
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              elevation: 6,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            child: Text(
              'Explore Orphanages',
              style: TextStyle(
                fontSize: FontSizes.f14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== Loading Animation =====
  Widget _buildLoadingAnimation() {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Center(
            child: Icon(
              Icons.favorite,
              color: AppColors.primary.withOpacity(0.5),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ===== Confetti Overlay =====
  Widget _buildConfettiOverlay() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        numberOfParticles: 50,
        gravity: 0.1,
        emissionFrequency: 0.05,
        colors: [
          AppColors.primary,
          AppColors.secondary,
          AppColors.blue,
          AppColors.primary.withOpacity(0.8),
          AppColors.secondary.withOpacity(0.8),
          AppColors.blue.withOpacity(0.8),
        ],
      ),
    );
  }
}
