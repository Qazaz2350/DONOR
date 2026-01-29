import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DonationPageView extends StatefulWidget {
  final String username;
  final String useremail;
  final String userphone;
  final Map<String, dynamic> orphanagedata;

  const DonationPageView({
    super.key,
    required this.orphanagedata,
    required this.username,
    required this.useremail,
    required this.userphone,
  });

  @override
  State<DonationPageView> createState() => _DonationPageViewState();
}

class _DonationPageViewState extends State<DonationPageView> {
  String selectedCategory = 'Money';
  bool isRecurring = false;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    quantityController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorViewModel(),
      child: Consumer<DonorViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: context.colors.surface,
            appBar: AppBar(
              title: Text(
                'Make a Donation',
                style: TextStyle(
                  fontSize: FontSizes.f20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _orphanageCard(),
                  SizedBox(height: 32.h),
                  _donationTypeSelector(),
                  SizedBox(height: 32.h),
                  _buildCustomFields(),
                  SizedBox(height: 32.h),
                  _donateButton(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= UI WIDGETS (NO CHANGE) =================

  IconData _getCategoryIcon(String category) {
    final icons = {
      'Money': Icons.attach_money_rounded,
      'Food': Icons.restaurant_rounded,
      'Clothes': Icons.checkroom_rounded,
      'Books': Icons.menu_book_rounded,
      'Toys': Icons.toys_rounded,
    };
    return icons[category] ?? Icons.volunteer_activism;
  }

  Widget _buildCustomFields() {
    if (selectedCategory == 'Money') {
      return _buildTextField(
        controller: amountController,
        label: 'Amount',
        hint: 'Enter donation amount',
        prefix: Text(
          '\$ ',
          style: TextStyle(
            fontSize: FontSizes.f16,
            fontWeight: FontWeight.w600,
          ),
        ),
        keyboardType: TextInputType.number,
      );
    } else {
      return Column(
        children: [
          _buildTextField(
            controller: quantityController,
            label: 'Quantity',
            hint: 'How many items?',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          _buildTextField(
            controller: notesController,
            label: 'Notes (optional)',
            hint: 'Add any special instructions',
            maxLines: 3,
          ),
        ],
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.f14,
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(fontSize: FontSizes.f14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix != null
                ? Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 14.h),
                    child: prefix,
                  )
                : null,
            filled: true,
            fillColor: context.colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }

  // ================= SEPARATED UI WIDGETS =================

  Widget _orphanageCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Donating to',
                  style: TextStyle(
                    fontSize: FontSizes.f12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.orphanagedata['orphanagename'] ??
                      widget.orphanagedata['name'] ??
                      'No Name',
                  style: TextStyle(
                    fontSize: FontSizes.f16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _donationTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Donation Type',
          style: TextStyle(
            fontSize: FontSizes.f16,
            fontWeight: FontWeight.bold,
            color: context.colors.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 12.h,
          children: ['Money', 'Food', 'Clothes', 'Books', 'Toys'].map((type) {
            bool selected = selectedCategory == type;
            return InkWell(
              onTap: () {
                setState(() {
                  selectedCategory = type;
                });
              },
              borderRadius: BorderRadius.circular(16.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : context.colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: selected ? AppColors.primary : Colors.grey.shade300,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(type),
                      color: selected ? Colors.white : context.colors.onSurface,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: FontSizes.f14,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : context.colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _donateButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.blue]),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<DonorViewModel>().handleDonateButton(
            context: context,
            name: widget.username,
            email: widget.useremail,
            phone: widget.userphone,
            orphanageData: widget.orphanagedata,
            category: selectedCategory,
            amountController: amountController,
            quantityController: quantityController,
            notesController: notesController,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_rounded, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              'Donate Now',
              style: TextStyle(
                fontSize: FontSizes.f16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
