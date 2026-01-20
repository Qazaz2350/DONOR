import 'package:donate/VIEWMODEL/SCREENS/ADMIN/admin_dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrphanagePage extends StatelessWidget {
  const AdminOrphanagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminOrphanageViewModel()..fetchOrphanages(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Admin Orphanages')),
        body: Consumer<AdminOrphanageViewModel>(
          builder: (_, vm, __) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.orphanages.isEmpty) {
              return const Center(child: Text('No orphanages found.'));
            }

            return ListView.builder(
              itemCount: vm.orphanages.length,
              itemBuilder: (_, index) {
                final o = vm.orphanages[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text(o.name),
                    subtitle: Text('Status: ${o.verificationStatus}'),
                    children: [
                      ListTile(title: Text('Address: ${o.address}')),
                      _documentRow('CNIC', o.cnicImage),
                      _documentRow('Registration', o.registrationDoc),
                      _documentRow('Signboard', o.signboardImage),
                      _imagesRow('Orphanage Images', o.orphanageImages),
                      ButtonBar(
                        children: [
                          ElevatedButton(
                            onPressed: o.verificationStatus == 'pending'
                                ? () => vm.approveOrphanage(o.id)
                                : null,
                            child: const Text('Approve'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: o.verificationStatus == 'pending'
                                ? () => vm.rejectOrphanage(o.id)
                                : null,
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _documentRow(String title, String url) {
    return ListTile(
      title: Text(title),
      trailing: url.isNotEmpty
          ? Image.network(url, width: 50, height: 50, fit: BoxFit.cover)
          : const Text('No Document'),
    );
  }

  Widget _imagesRow(String title, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: images
                .map(
                  (url) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      url,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
