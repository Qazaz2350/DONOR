import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_dashboard_view.dart';
import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/orphanage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrphanagWaitingView extends StatelessWidget {
  const OrphanagWaitingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrphanageViewModel>(
      builder: (context, vm, _) {
        // ✅ Navigate when verified
        if (vm.isVerified) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OrphanageDashboardView()),
            );
          });
        }

        // ❌ Waiting UI
        return Scaffold(
          appBar: AppBar(title: const Text('Verification Status')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Waiting for approval',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Your account is under review',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
