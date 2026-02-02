import 'package:donate/VIEW/login/signin_view.dart';
import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/Orphanage_View_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrphanageSignupView extends StatelessWidget {
  const OrphanageSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrphanageViewModel>(
      builder: (context, vm, child) {
        return vm.isVerified
            ? const Scaffold(
                body: Center(child: Text('Registered successfully')),
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
                        const SizedBox(height: 12),

                        // CNIC
                        TextFormField(
                          controller: vm.cnicController,
                          decoration: const InputDecoration(
                            labelText: 'CNIC Number',
                            hintText: '12345-1234567-1',
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // CNIC Image
                        const Text('Upload CNIC Image'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          // onTap: () => vm.pickImage('cnic'),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: vm.cnicImage != null
                                ? Image.file(vm.cnicImage!, fit: BoxFit.cover)
                                : const Center(child: Icon(Icons.add_a_photo)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Signboard Image
                        const Text('Upload Signboard Image'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          // onTap: () => vm.pickImage('signboard'),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: vm.signboardImage != null
                                ? Image.file(
                                    vm.signboardImage!,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(child: Icon(Icons.add_a_photo)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Orphanage Image
                        const Text('Upload Orphanage Image'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          // onTap: () => vm.pickImage('orphanage'),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: vm.orphanageImage != null
                                ? Image.file(
                                    vm.orphanageImage!,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(child: Icon(Icons.add_a_photo)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Location Section
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.my_location),
                                label: Text(
                                  vm.isLocationLoading
                                      ? 'Fetching...'
                                      : 'Get Current Location',
                                ),
                                onPressed: vm.isLocationLoading
                                    ? null
                                    : () async {
                                        await vm.fetchLiveLocation(context);
                                      },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (vm.latitude != null && vm.longitude != null)
                          Text(
                            'Latitude: ${vm.latitude}, Longitude: ${vm.longitude}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        const SizedBox(height: 24),

                        // Submit Button
                        ElevatedButton(
                          onPressed: () async {
                            if (!vm.validateForm()) return;

                            // Optional: attach location before submission
                            if (vm.latitude != null && vm.longitude != null) {
                              // You can modify your submitOrphanage method to accept lat/lng
                            }

                            await vm.submitOrphanage(context);

                            // Navigate to SignInScreenView after submission
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreenView(),
                              ),
                            );
                          },
                          child: const Text('Submit for Verification'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
