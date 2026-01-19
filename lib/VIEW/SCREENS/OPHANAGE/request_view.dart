import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/Orphanage_View_Model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'orphanage_view_model.dart'; // import your ViewModel

class OrphanageRequestView extends StatelessWidget {
  const OrphanageRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrphanageViewModel(),
      child: Consumer<OrphanageViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Orphanage Form')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: vm.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Basic Info =====
                    TextFormField(
                      controller: vm.nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (val) => val!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: vm.addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (val) => val!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: vm.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      controller: vm.phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Phone',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // ===== Verified =====
                    SwitchListTile(
                      title: const Text('Verified'),
                      value: vm.verified,
                      onChanged: vm.toggleVerified,
                    ),

                    // ===== Images =====
                    const Text('Images'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: vm.addImage,
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      children: vm.images
                          .map((img) => Chip(label: Text(img)))
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // ===== Needs =====
                    const Text('Needs'),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: vm.needController,
                            decoration: const InputDecoration(
                              labelText: 'Need',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: vm.addAdditionalNeed,
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      children: vm.additionalNeeds
                          .map((need) => Chip(label: Text(need)))
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // ===== Donation History =====
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Text(
                    //       'Donation History',
                    //       style: TextStyle(fontSize: 16),
                    //     ),
                    //     IconButton(
                    //       onPressed: vm.addDonationHistory,
                    //       icon: const Icon(Icons.add),
                    //     ),
                    //   ],
                    // ),
                    // ...vm.donationHistory.asMap().entries.map((entry) {
                    //   int i = entry.key;
                    //   var donation = entry.value;
                    //   return Card(
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               labelText: 'Donor ID',
                    //             ),
                    //             onChanged: (val) => donation['donorId'] = val,
                    //           ),
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               labelText: 'Type',
                    //             ),
                    //             onChanged: (val) => donation['type'] = val,
                    //           ),
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               labelText: 'Quantity',
                    //             ),
                    //             keyboardType: TextInputType.number,
                    //             onChanged: (val) => donation['quantity'] =
                    //                 int.tryParse(val) ?? 0,
                    //           ),
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               labelText: 'Amount',
                    //             ),
                    //             keyboardType: TextInputType.number,
                    //             onChanged: (val) => donation['amount'] =
                    //                 double.tryParse(val) ?? 0,
                    //           ),
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               labelText: 'Date',
                    //             ),
                    //             readOnly: true,
                    //             controller: TextEditingController(
                    //               text: DateFormat(
                    //                 'yyyy-MM-dd',
                    //               ).format(donation['date']),
                    //             ),
                    //             onTap: () async {
                    //               DateTime? picked = await showDatePicker(
                    //                 context: context,
                    //                 initialDate: donation['date'],
                    //                 firstDate: DateTime(2000),
                    //                 lastDate: DateTime(2100),
                    //               );
                    //               if (picked != null) {
                    //                 donation['date'] = picked;
                    //                 vm.notifyListeners();
                    //               }
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   );
                    // }),
                    const SizedBox(height: 20),

                    // ===== Stories =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Stories', style: TextStyle(fontSize: 16)),
                        IconButton(
                          onPressed: vm.addStory,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    ...vm.stories.asMap().entries.map((entry) {
                      int i = entry.key;
                      var story = entry.value;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                ),
                                onChanged: (val) => story['title'] = val,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Content',
                                ),
                                maxLines: 2,
                                onChanged: (val) => story['content'] = val,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Date',
                                ),
                                readOnly: true,
                                controller: TextEditingController(
                                  text: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(story['date']),
                                ),
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: story['date'],
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    story['date'] = picked;
                                    vm.notifyListeners();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // ===== Volunteering Events =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Volunteering Events',
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: vm.addEvent,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    ...vm.volunteeringEvents.asMap().entries.map((entry) {
                      int i = entry.key;
                      var event = entry.value;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'ID',
                                ),
                                onChanged: (val) => event['id'] = val,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                ),
                                onChanged: (val) => event['title'] = val,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                ),
                                onChanged: (val) => event['description'] = val,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Capacity',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) =>
                                    event['capacity'] = int.tryParse(val) ?? 0,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Registered',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) => event['registered'] =
                                    int.tryParse(val) ?? 0,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Date',
                                ),
                                readOnly: true,
                                controller: TextEditingController(
                                  text: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(event['date']),
                                ),
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: event['date'],
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    event['date'] = picked;
                                    vm.notifyListeners();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // ===== Submit Button =====
                    Center(
                      child: ElevatedButton(
                        onPressed: () => vm.submitOrphanage(context),
                        child: const Text('Submit'),
                      ),
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
