import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/Orphanage_View_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrphanageSignupView extends StatelessWidget {
  const OrphanageSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrphanageViewModel(),
      child: Consumer<OrphanageViewModel>(
        builder: (context, vm, child) {
          return vm.isVerified
              ? Scaffold(
                  // appBar: AppBar(title: const Text('Register Orphanage')),
                  body: Center(child: Text('Regiser successfully ')),
                )
              : Scaffold(
                  appBar: AppBar(title: const Text('Register Orphanage')),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: vm.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Orphanage Name
                          TextFormField(
                            controller: vm.nameController,
                            decoration: const InputDecoration(
                              labelText: 'Orphanage Name',
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          // Email
                          TextFormField(
                            controller: vm.emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          // Phone
                          TextFormField(
                            controller: vm.phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          // Address
                          TextFormField(
                            controller: vm.addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Needs selection
                          const Text('Select Needs:'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            children: vm.needs.keys.map((need) {
                              return FilterChip(
                                label: Text(need),
                                selected: vm.needs[need]!,
                                onSelected: (val) => vm.toggleNeed(need, val),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Submit Button
                          ElevatedButton(
                            onPressed: () async {
                              if (!vm.validateForm()) return;

                              await vm.submitOrphanage(context);
                            },
                            child: const Text('Submit for Verification'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
