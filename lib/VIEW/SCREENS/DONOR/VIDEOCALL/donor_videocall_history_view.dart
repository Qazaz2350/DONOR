import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/Utilis/app_colors.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// ... (all your imports remain the same)

class VideoCallRequestsUI extends StatefulWidget {
  const VideoCallRequestsUI({super.key});

  @override
  State<VideoCallRequestsUI> createState() => _VideoCallRequestsUIState();
}

class _VideoCallRequestsUIState extends State<VideoCallRequestsUI> {
  @override
  void initState() {
    super.initState();
    // Fetch data after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<DonorViewModel>(context, listen: false);
      vm.fetchVideoCallRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DonorViewModel>(
        builder: (context, vm, child) {
          if (vm.isFetchingVideoCalls) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.videoCallRequests.isEmpty) {
            return const Center(
              child: Text(
                'No video call requests',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => vm.fetchVideoCallRequests(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.videoCallRequests.length,
              itemBuilder: (context, index) {
                final item = vm.videoCallRequests[index];

                final requestTime =
                    (item['requestTime'] as Timestamp?)?.toDate();
                final scheduledTime =
                    (item['scheduledTime'] as Timestamp?)?.toDate();
                final statusRaw = item['videocallstatus'] ?? 'pending';
                final status = statusRaw.toLowerCase();

                Color statusColor;
                switch (status) {
                  case 'rejected':
                    statusColor = Colors.red;
                    break;
                  case 'requestaccepted':
                  case 'accepted': // just in case
                    statusColor = Colors.green;
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

                        // ===== Request Time =====
                        _buildInfoRow(
                          Icons.access_time,
                          'Request',
                          requestTime,
                        ),
                        const SizedBox(height: 6),

                        // ===== Scheduled Time =====
                        _buildInfoRow(
                          Icons.schedule,
                          'Scheduled',
                          scheduledTime,
                        ),

                        if (status == 'rejected' &&
                            item['rejectionReason'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Reason: ${item['rejectionReason']}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),

                        const SizedBox(height: 12),

                        // ===== Action Buttons =====
                        // Show "Start Video Call" button only if videocallstatus is RequestAccepted
                        // if (statusRaw == 'RequestAccepted')
                        ElevatedButton.icon(
                          onPressed: () {
                            print("imhere 1");
                            vm.startVideoCall(
                              context: context,
                              requestData: item,
                            );
                          },
                          icon: const Icon(Icons.video_call),
                          label: const Text(
                            'Start Video Call',
                            style: TextStyle(color: AppColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            minimumSize: const Size(double.infinity, 0),
                          ),
                        ),

                        // Cancel button for pending requests
                        if (status == 'pending')
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _cancelRequest(vm, item),
                                  icon: const Icon(Icons.cancel, size: 18),
                                  label: const Text('Cancel Request'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildInfoRow(IconData icon, String label, DateTime? time) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          '$label: ${time != null ? DateFormat('MMMM dd, yyyy • hh:mm a').format(time) : 'N/A'}',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Future<void> _cancelRequest(
    DonorViewModel vm,
    Map<String, dynamic> request,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text(
          'Are you sure you want to cancel this video call request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true && request['id'] != null) {
      try {
        await FirebaseFirestore.instance
            .collection('videocallrequest')
            .doc(request['id'])
            .update({'videocallstatus': 'cancelled'});

        // Refresh the list
        vm.fetchVideoCallRequests();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Request cancelled')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
