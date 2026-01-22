import 'dart:io';
import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/Orphanage_View_Model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:donate/VIEWMODEL/SCREENS/OPHANAGE/orphanage_viewmodel.dart';

class OrphanageRequestView extends StatefulWidget {
  const OrphanageRequestView({super.key});

  @override
  State<OrphanageRequestView> createState() => _OrphanageRequestViewState();
}

class _OrphanageRequestViewState extends State<OrphanageRequestView> {
  final List<TextEditingController> _needsControllers = [];
  final List<Map<String, TextEditingController>> _storiesControllers = [];
  final List<Map<String, TextEditingController>> _eventsControllers = [];
  final List<File> _extraImages = [];

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) return File(pickedFile.path);
    return null;
  }

  Widget _buildImagePicker(
    String label,
    File? file,
    void Function(File?) onSelect,
  ) {
    return GestureDetector(
      onTap: () async {
        final img = await _pickImage();
        if (img != null) onSelect(img);
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: file != null
            ? Image.file(file, fit: BoxFit.cover)
            : Center(child: Text('Select $label')),
      ),
    );
  }

  Widget _buildExtraImagesPicker() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._extraImages.map(
          (img) => Stack(
            children: [
              Image.file(img, width: 100, height: 100, fit: BoxFit.cover),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _extraImages.remove(img);
                    });
                  },
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            final img = await _pickImage();
            if (img != null) {
              setState(() {
                _extraImages.add(img);
              });
            }
          },
          child: Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrphanageViewModel(),
      child: Consumer<OrphanageViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Submit OFFD Orphanage')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: vm.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Basic Fields =====

                    // ===== Main Images =====
                    _buildImagePicker(
                      'CNIC Image',
                      vm.cnicImage,
                      (file) => vm.cnicImage = file,
                    ),
                    const SizedBox(height: 12),
                    _buildImagePicker(
                      'Signboard Image',
                      vm.signboardImage,
                      (file) => vm.signboardImage = file,
                    ),
                    const SizedBox(height: 12),
                    _buildImagePicker(
                      'Orphanage Image',
                      vm.orphanageImage,
                      (file) => vm.orphanageImage = file,
                    ),
                    const SizedBox(height: 20),

                    // ===== Extra Images =====
                    const Text(
                      'Extra Images',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildExtraImagesPicker(),
                    const SizedBox(height: 20),

                    // ===== Needs =====
                    const Text(
                      'Needs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._needsControllers.map(
                      (c) => Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: c,
                              decoration: const InputDecoration(
                                labelText: 'Need',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _needsControllers.remove(c);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _needsControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Need'),
                    ),
                    const SizedBox(height: 20),

                    // ===== Stories =====
                    const Text(
                      'Stories',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._storiesControllers.map(
                      (map) => Column(
                        children: [
                          TextFormField(
                            controller: map['title'],
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          TextFormField(
                            controller: map['description'],
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _storiesControllers.remove(map);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _storiesControllers.add({
                            'title': TextEditingController(),
                            'description': TextEditingController(),
                          });
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Story'),
                    ),
                    const SizedBox(height: 20),

                    // ===== Volunteering Events =====
                    const Text(
                      'Volunteering Events',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._eventsControllers.map(
                      (map) => Column(
                        children: [
                          TextFormField(
                            controller: map['name'],
                            decoration: const InputDecoration(
                              labelText: 'Event Name',
                            ),
                          ),
                          TextFormField(
                            controller: map['date'],
                            decoration: const InputDecoration(
                              labelText: 'Event Date',
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _eventsControllers.remove(map);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _eventsControllers.add({
                            'name': TextEditingController(),
                            'date': TextEditingController(),
                          });
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Event'),
                    ),
                    const SizedBox(height: 24),

                    // ===== Submit Button =====
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (vm.validateForm()) {
                            // Prepare data arrays
                            final needs = _needsControllers
                                .map((c) => c.text)
                                .toList();
                            final stories = _storiesControllers
                                .map(
                                  (m) => {
                                    'title': m['title']!.text,
                                    'description': m['description']!.text,
                                  },
                                )
                                .toList();
                            final events = _eventsControllers
                                .map(
                                  (m) => {
                                    'name': m['name']!.text,
                                    'date': m['date']!.text,
                                  },
                                )
                                .toList();
                            final images = _extraImages
                                .map((f) => f.path)
                                .toList();

                            await vm.submitOffdOrphanage(
                              context,
                              images: images,
                              needs: needs,
                              stories: stories,
                              volunteeringEvents: events,
                              verified: false,
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Submit Orphanage'),
                        ),
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
