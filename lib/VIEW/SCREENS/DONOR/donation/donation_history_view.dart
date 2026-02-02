import 'package:donate/Utilis/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DonationHistoryView extends StatefulWidget {
  const DonationHistoryView({super.key});

  @override
  State<DonationHistoryView> createState() => _DonationHistoryViewState();
}

class _DonationHistoryViewState extends State<DonationHistoryView> {
  @override
  void initState() {
    super.initState();
    // Fetch donations when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final donorVM = context.read<DonorViewModel>();
      donorVM.fetchUserDonations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Donations'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DonorViewModel>(
        builder: (context, donorVM, _) {
          if (donorVM.isFetchingDonations) {
            return _buildLoadingState();
          }

          if (donorVM.donationError != null) {
            return _buildErrorState(donorVM.donationError!);
          }

          if (donorVM.userDonations.isEmpty) {
            return _buildEmptyState();
          }

          return _buildDonationList(donorVM.userDonations);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your donations...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading donations',
              style: TextStyle(
                fontSize: FontSizes.f16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<DonorViewModel>().fetchUserDonations();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.volunteer_activism_outlined,
              size: 64,
              color: AppColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Donations Yet',
              style: TextStyle(
                fontSize: FontSizes.f20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your donation history will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationList(List donations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        return _buildDonationCard(donation);
      },
    );
  }

  Widget _buildDonationCard(dynamic donation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Orphanage name
            Text(
              donation.foundationName ?? 'Unknown Foundation',
              style: TextStyle(
                fontSize: FontSizes.f16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Category and amount/quantity
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    donation.category ?? 'General',
                    style: TextStyle(
                      fontSize: FontSizes.f12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  donation.amount != null
                      ? 'Rs ${donation.amount!.toStringAsFixed(0)}'
                      : 'Qty: ${donation.quantity ?? 0}',
                  style: TextStyle(
                    fontSize: FontSizes.f14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Notes (if any)
            if (donation.notes != null && donation.notes!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    donation.notes!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),

            // Date
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(donation.timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
