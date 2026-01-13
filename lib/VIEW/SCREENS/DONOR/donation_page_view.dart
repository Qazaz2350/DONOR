import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonationPageView extends StatefulWidget {
  final String orphanage_name;
  const DonationPageView({super.key, required this.orphanage_name});

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
    return Scaffold(
      backgroundColor: context.colors.background,
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
      body: _buildUI(context),
    );
  }

  void _processPayment() async {
    double amount = double.tryParse(amountController.text) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter a valid amount'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment Successful! Amount: \$${amount.toStringAsFixed(2)}',
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

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

  // ✅ UI SEPARATED HERE — NOTHING INSIDE CHANGED
  Widget _buildUI(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Orphanage Card
          Container(
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
                        widget.orphanage_name,
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
          ),
          SizedBox(height: 32.h),

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 13.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : context.colors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: selected ? 2 : 1,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(type),
                        color: selected
                            ? Colors.white
                            : context.colors.onSurface,
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

          SizedBox(height: 32.h),
          _buildCustomFields(),
          SizedBox(height: 32.h),

          // Container(
          //   padding: EdgeInsets.all(20.w),
          //   decoration: BoxDecoration(
          //     color: context.colors.surface,
          //     borderRadius: BorderRadius.circular(16.r),
          //     border: Border.all(color: Colors.grey.shade300, width: 1),
          //   ),
          //   child: Row(
          //     children: [
          //       Container(
          //         padding: EdgeInsets.all(10.w),
          //         decoration: BoxDecoration(
          //           color: AppColors.secondary.withOpacity(0.1),
          //           borderRadius: BorderRadius.circular(12.r),
          //         ),
          //         child: Icon(
          //           Icons.autorenew_rounded,
          //           color: AppColors.secondary,
          //           size: 24.sp,
          //         ),
          //       ),
          //       SizedBox(width: 16.w),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               'Recurring Donation',
          //               style: TextStyle(
          //                 fontSize: FontSizes.f14,
          //                 fontWeight: FontWeight.w600,
          //                 color: context.colors.onSurface,
          //               ),
          //             ),
          //             SizedBox(height: 4.h),
          //             Text(
          //               'Make this a monthly donation',
          //               style: TextStyle(
          //                 fontSize: FontSizes.f12,
          //                 color: Colors.grey.shade600,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Switch(
          //         value: isRecurring,
          //         onChanged: (val) {
          //           setState(() {
          //             isRecurring = val;
          //           });
          //         },
          //         activeColor: AppColors.secondary,
          //       ),
          //     ],
          //   ),
          // ),

          // SizedBox(height: 40.h),
          Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.blue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              // boxShadow: [
              //   BoxShadow(
              //     color: AppColors.primary.withOpacity(0.4),
              //     blurRadius: 20,
              //     offset: Offset(0, 10),
              //   ),
              // ],
            ),
            child: ElevatedButton(
              onPressed: _processPayment,
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
                  Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
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
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
