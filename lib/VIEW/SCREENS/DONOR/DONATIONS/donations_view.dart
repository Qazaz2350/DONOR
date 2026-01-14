import 'package:donate/Utilis/extention.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DonationHistoryPage extends StatefulWidget {
  final DonorViewModel vm;

  const DonationHistoryPage({Key? key, required this.vm}) : super(key: key);

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  bool _sortAscending = true;

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Shipped":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  List _getSortedDonations() {
    final donations = List.from(widget.vm.donationHistory);
    donations.sort((a, b) {
      if (_sortAscending) {
        return a.orphanageName.toLowerCase().compareTo(
          b.orphanageName.toLowerCase(),
        );
      } else {
        return b.orphanageName.toLowerCase().compareTo(
          a.orphanageName.toLowerCase(),
        );
      }
    });
    return donations;
  }

  @override
  Widget build(BuildContext context) {
    final donations = _getSortedDonations();

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          "Donation History",
          style: TextStyle(
            fontSize: FontSizes.f20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: context.colors.onSurface,
            ),
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
            tooltip: _sortAscending ? "Sort Z-A" : "Sort A-Z",
          ),
        ],
      ),
      body: donations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80.sp,
                    color: context.colors.onSurface.withOpacity(0.3),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No donations yet.",
                    style: TextStyle(
                      fontSize: FontSizes.f16,
                      color: context.colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = donations[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              donation.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            widget.vm.getDonationIcon(donation.type),
                            color: _getStatusColor(donation.status),
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Type and Amount
                              Text(
                                donation.type == "Money"
                                    ? "${donation.type}: \$${donation.amount?.toStringAsFixed(2)}"
                                    : donation.type,
                                style: TextStyle(
                                  fontSize: FontSizes.f16,
                                  fontWeight: FontWeight.w700,
                                  color: context.colors.onSurface,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              // Orphanage Name
                              Row(
                                children: [
                                  Icon(
                                    Icons.home_outlined,
                                    size: 14.sp,
                                    color: context.colors.onSurface.withOpacity(
                                      0.6,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      donation.orphanageName,
                                      style: TextStyle(
                                        fontSize: FontSizes.f14,
                                        color: context.colors.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              // Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14.sp,
                                    color: context.colors.onSurface.withOpacity(
                                      0.6,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy',
                                    ).format(donation.date),
                                    style: TextStyle(
                                      fontSize: FontSizes.f12,
                                      color: context.colors.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              donation.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: _getStatusColor(donation.status),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            donation.status,
                            style: TextStyle(
                              fontSize: FontSizes.f12,
                              color: _getStatusColor(donation.status),
                              fontWeight: FontWeight.w600,
                            ),
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
