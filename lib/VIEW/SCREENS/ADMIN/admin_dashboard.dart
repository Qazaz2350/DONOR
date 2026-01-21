import 'package:donate/VIEWMODEL/SCREENS/ADMIN/admin_dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrphanagePage extends StatelessWidget {
  const AdminOrphanagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminViewModel()..fetchUsers(),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin Panel'),
            centerTitle: true,
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Donation Monitoring', icon: Icon(Icons.monitor)),
                Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
                Tab(
                  text: 'Approval / Rejection',
                  icon: Icon(Icons.check_circle),
                ),
                Tab(text: 'History', icon: Icon(Icons.history)),
              ],
            ),
          ),
          body: Consumer<AdminViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Separate data
              final waitingOrphanages = vm.orphanages
                  .where((o) => o['status'] == 'AdminApprovalWaiting')
                  .toList();

              return TabBarView(
                children: [
                  // 1️⃣ Donation Monitoring
                  RefreshIndicator(
                    onRefresh: vm.fetchUsers,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'Donors',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...vm.donors.map(
                          (data) => Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                data['fullName'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('Email: ${data['email'] ?? ''}'),
                                  Text('Phone: ${data['phone'] ?? ''}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2️⃣ Analytics placeholder
                  Center(
                    child: Text(
                      'Analytics & Insights coming soon',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),

                  // 3️⃣ Approval / Rejection
                  RefreshIndicator(
                    onRefresh: vm.fetchUsers,
                    child: waitingOrphanages.isEmpty
                        ? const Center(
                            child: Text(
                              'No orphanages waiting for approval.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: waitingOrphanages.length,
                            itemBuilder: (context, index) {
                              final data = waitingOrphanages[index];
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data['fullName'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Waiting',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text('Email: ${data['email'] ?? ''}'),
                                      Text('Phone: ${data['phone'] ?? ''}'),
                                      Text('Address: ${data['address'] ?? ''}'),
                                      Text('CNIC: ${data['cnic'] ?? ''}'),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Profile: ${(data['profile'] as List<String>?)?.join(', ') ?? ''}',
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                vm.setAdminApproval(
                                                  orphanageId: data['id'],
                                                  approve: true,
                                                );
                                              },
                                              child: const Text('Approve'),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                vm.setAdminApproval(
                                                  orphanageId: data['id'],
                                                  approve: false,
                                                );
                                              },
                                              child: const Text('Reject'),
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
                  ),

                  // 4️⃣ History (timeline style)
                  vm.adminActions.isEmpty
                      ? const Center(
                          child: Text(
                            'No admin actions yet.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: vm.adminActions.length,
                          itemBuilder: (context, index) {
                            final action = vm.adminActions[index];
                            final timestamp = action['timestamp'] != null
                                ? (action['timestamp'] as Timestamp).toDate()
                                : null;
                            final isApproved = action['action'] == 'Approved';

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Timeline dot
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: isApproved
                                        ? Colors.green
                                        : Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.only(
                                      bottom: 16,
                                      right: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            action['orphanageName'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Action: ${action['action']}',
                                            style: TextStyle(
                                              color: isApproved
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (timestamp != null)
                                            Text(
                                              'Date: ${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
