import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/Orphanage_View_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrphanageHomeView extends StatelessWidget {
  const OrphanageHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrphanageViewModel(),
      child: Consumer<OrphanageViewModel>(
        builder: (context, vm, child) {
          // Fetch profile and video calls once after first frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!vm.isLoadingProfile && vm.orphanagename == null) {
              vm.fetchOrphanageProfile();
            }
            if (!vm.isLoadingVideoCalls && vm.videoCallRequests.isEmpty) {
              vm.fetchVideoCallRequests();
            }
          });

          // Filter requests only for this orphanage and pending
          final filteredRequests = vm.videoCallRequests
              .where(
                (req) =>
                    req['orphanageName'] != null &&
                    req['orphanageName'] == vm.orphanagename &&
                    (req['status'] == null || req['status'] == 'Pending'),
              )
              .toList();

          return Scaffold(
            body: vm.isLoadingProfile
                ? const Center(child: CircularProgressIndicator())
                : vm.orphanagename == null
                ? const Center(child: Text("No orphanage profile found."))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${vm.orphanagename ?? ''}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ===== Video Call Requests Section =====
                        const Text(
                          "Video Call Requests",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        vm.isLoadingVideoCalls
                            ? const Center(child: CircularProgressIndicator())
                            : filteredRequests.isEmpty
                            ? const Text("No video call requests for you.")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredRequests.length,
                                itemBuilder: (context, index) {
                                  final request = filteredRequests[index];
                                  final dateTime =
                                      (request['scheduledTime'] as Timestamp?)
                                          ?.toDate();
                                  final status =
                                      (request['videocallstatus'] as String?)
                                          ?.toLowerCase() ??
                                      'pending';

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        request['donorName'] ?? 'Unknown Donor',
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Scheduled: ${dateTime != null ? dateTime.toString() : 'N/A'}',
                                          ),
                                          if (status != 'pending')
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4.0,
                                              ),
                                              child: Text(
                                                'Status: ${status[0].toUpperCase()}${status.substring(1)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: status == 'accepted'
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: status == 'pending'
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      vm.acceptVideoCall(
                                                        request['id'],
                                                        context,
                                                      ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                  child: const Text('Accept'),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      vm.rejectVideoCall(
                                                        request['id'],
                                                        context,
                                                      ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                  child: const Text('Reject'),
                                                ),
                                              ],
                                            )
                                          : null, // hide buttons if not pending
                                    ),
                                  );
                                },
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
