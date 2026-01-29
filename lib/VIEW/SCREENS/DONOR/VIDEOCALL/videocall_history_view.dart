import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/Utilis/app_colors.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class VideoCallRequestsUI extends StatelessWidget {
  const VideoCallRequestsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorViewModel()..fetchVideoCallRequests(),
      child: Consumer<DonorViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: vm.isFetchingVideoCalls
                ? const Center(child: CircularProgressIndicator())
                : vm.videoCallRequests.isEmpty
                ? const Center(
                    child: Text(
                      'No video call requests',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.videoCallRequests.length,
                    itemBuilder: (context, index) {
                      final item = vm.videoCallRequests[index];

                      final requestTime = item['requestTime'] != null
                          ? (item['requestTime'] as Timestamp).toDate()
                          : null;
                      final scheduledTime = item['scheduledTime'] != null
                          ? (item['scheduledTime'] as Timestamp).toDate()
                          : null;

                      final status = (item['videocallstatus'] ?? 'pending')
                          .toLowerCase();

                      Color statusColor;
                      switch (status) {
                        case 'accepted':
                          statusColor = Colors.green;
                          break;
                        case 'rejected':
                          statusColor = Colors.red;
                          break;
                        default:
                          statusColor = Colors.orange;
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ===== Header =====
                              Row(
                                children: [
                                  const Icon(
                                    Icons.home_outlined,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item['orphanageName'] ?? 'Orphanage',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // ===== Request & Scheduled Time =====
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Request: ${requestTime != null ? DateFormat('MMMM dd, yyyy • hh:mm a').format(requestTime) : 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Scheduled: ${scheduledTime != null ? DateFormat('MMMM dd, yyyy • hh:mm a').format(scheduledTime) : 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // ===== Action Buttons =====
                              if (status == 'pending')
                                Row(children: [const SizedBox(width: 8)])
                              else if (status == 'accepted')
                                ElevatedButton.icon(
                                  onPressed: () {
                                    print(
                                      'Start video call with ${item['orphanageName']}',
                                    );
                                  },
                                  icon: const Icon(Icons.video_call),
                                  label: const Text(
                                    'Start Video Call',
                                    style: TextStyle(color: AppColors.white),
                                  ),

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
