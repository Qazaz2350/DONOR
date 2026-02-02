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
          // Fetch profile once after first frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!vm.isLoadingProfile && vm.orphanagename == null) {
              vm.fetchOrphanageProfile();
            }
          });

          return Scaffold(
            body: Center(
              child: vm.isLoadingProfile
                  ? const CircularProgressIndicator()
                  : vm.orphanagename == null
                  ? const Text("No orphanage profile found.")
                  : Text(
                      "Welcome, ${vm.orphanagename}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
