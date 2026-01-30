import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/Orphanage_View_Model.dart';

class Orphanageprofileview extends StatelessWidget {
  const Orphanageprofileview({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrphanageViewModel()..fetchMyProfile(),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
        body: Consumer<OrphanageViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoadingProfile) {
              return const Center(child: CircularProgressIndicator());
            }

            final fullname = vm.orphanagename ?? '';
            final email = vm.email ?? '';
            final phone = vm.phone ?? '';
            final address = vm.orphanageaddress ?? '';
            final status = vm.status ?? '';
            final cnic = vm.cnic ?? '';
            final needs = vm.needs ?? [];
            final additionalImages = vm.additionalImages ?? [];
            final stories = vm.stories ?? [];
            final volunteeringEvents = vm.volunteeringEvents ?? [];
            final verified = vm.verified;
            final createdAt = vm.createdAt;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        fullname.isNotEmpty ? fullname[0].toUpperCase() : 'O',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Basic Info Section
                  _buildSectionTitle('Basic Information'),
                  _infoCard('Full Name', fullname, Icons.person),
                  _infoCard('Email', email, Icons.email),
                  _infoCard('Phone', phone, Icons.phone),
                  _infoCard('Address', address, Icons.location_on),
                  // _infoCard('Status', status, Icons.status),
                  _infoCard('CNIC', cnic, Icons.badge),
                  _infoCard(
                    'Verified',
                    verified ? 'Yes' : 'No',
                    Icons.verified,
                  ),
                  _infoCard(
                    'Created At',
                    createdAt != null
                        ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
                        : 'N/A',
                    Icons.calendar_today,
                  ),

                  const SizedBox(height: 24),

                  // Needs Section
                  _buildEditableSection(
                    title: 'Current Needs',
                    items: needs,
                    onEdit: () => _showEditNeedsDialog(context, vm),
                    onAdd: () => _showAddNeedDialog(context, vm),
                    itemBuilder: (item, index) => _needChip(item, () {
                      vm.removeNeed(context, index);
                    }),
                  ),

                  const SizedBox(height: 24),

                  // Stories Section
                  _buildEditableSection(
                    title: 'Our Stories',
                    items: stories,
                    onEdit: null,
                    onAdd: () => _showAddStoryDialog(context, vm),
                    itemBuilder: (item, index) => _storyCard(
                      item['title'] ?? 'Untitled',
                      item['description'] ?? '',
                      () => _showStoryDetails(context, item),
                      () => vm.removeStory(context, index),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Volunteering Events Section
                  _buildEditableSection(
                    title: 'Volunteering Events',
                    items: volunteeringEvents,
                    onEdit: null,
                    onAdd: () => _showAddEventDialog(context, vm),
                    itemBuilder: (item, index) => _eventCard(
                      item['title'] ?? 'Untitled Event',
                      item['date'] ?? 'Not set',
                      item['time'] ?? 'Not set',
                      () => _showEventDetails(context, item),
                      () => vm.removeEvent(context, index),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Gallery Section
                  _buildEditableSection(
                    title: 'Photo Gallery',
                    items: additionalImages,
                    onEdit: null,
                    onAdd: () => _pickImage(context, vm),
                    itemBuilder: (item, index) => _imageThumbnail(
                      item,
                      () => vm.removeImage(context, index),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ===== UI COMPONENTS =====

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : 'Not provided',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEditableSection({
    required String title,
    required List items,
    required VoidCallback? onEdit,
    required VoidCallback onAdd,
    required Widget Function(dynamic, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (onEdit != null)
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue.shade700),
                    onPressed: onEdit,
                    tooltip: 'Edit $title',
                  ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green.shade700),
                  onPressed: onAdd,
                  tooltip: 'Add to $title',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'No $title added yet',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          ...items.asMap().entries.map((entry) {
            return itemBuilder(entry.value, entry.key);
          }),
      ],
    );
  }

  Widget _needChip(String need, VoidCallback onDelete) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Chip(
        label: Text(need),
        backgroundColor: Colors.blue.shade50,
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onDelete,
      ),
    );
  }

  Widget _storyCard(
    String title,
    String description,
    VoidCallback onTap,
    VoidCallback onDelete,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.purple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          description.length > 60
              ? '${description.substring(0, 60)}...'
              : description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _eventCard(
    String title,
    String date,
    String time,
    VoidCallback onTap,
    VoidCallback onDelete,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Date: $date'), Text('Time: $time')],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _imageThumbnail(String imageUrl, VoidCallback onDelete) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== DIALOG METHODS =====

  void _showEditNeedsDialog(BuildContext context, OrphanageViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit All Needs'),
        content: TextField(
          controller: vm.needsController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter needs separated by commas',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              vm.saveNeeds(context);
              Navigator.pop(context);
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showAddNeedDialog(BuildContext context, OrphanageViewModel vm) {
    final needController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Need'),
        content: TextField(
          controller: needController,
          decoration: const InputDecoration(
            labelText: 'Need',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Changed to async
              if (needController.text.trim().isNotEmpty) {
                await vm.addNeed(
                  needController.text.trim(),
                  context,
                ); // Pass context
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddStoryDialog(BuildContext context, OrphanageViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Story'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: vm.storyTitleController,
                decoration: const InputDecoration(
                  labelText: 'Story Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: vm.storyDescriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Story Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              vm.addStory(context);
              Navigator.pop(context);
            },
            child: const Text('Add Story'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, OrphanageViewModel vm) {
    // ✅ FRESH controllers for THIS dialog only
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController, // ✅ Fresh controller
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController, // ✅ Fresh controller
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dateController, // ✅ Fresh controller
                decoration: const InputDecoration(
                  labelText: 'Date (e.g., 30 Jan 2024)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController, // ✅ Fresh controller
                decoration: const InputDecoration(
                  labelText: 'Time (e.g., 2:30 PM)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final desc = descController.text.trim();
              final date = dateController.text.trim();
              final time = timeController.text.trim();

              // if (title.isEmpty ||
              //     desc.isEmpty ||
              //     date.isEmpty ||
              //     time.isEmpty) {
              //   _showSnack(context, 'Please fill all event fields');
              //   return;
              // }

              // ✅ Use ViewModel method but pass values, not controllers
              await vm.addVolunteeringEventWithData(
                context,
                title: title,
                description: desc,
                date: date,
                time: time,
              );

              Navigator.pop(context);
            },
            child: const Text('Add Event'),
          ),
        ],
      ),
    );
  }

  void _pickImage(BuildContext context, OrphanageViewModel vm) {
    // This would typically use image_picker
    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Image'),
        content: const Text('Image picker functionality would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showStoryDetails(BuildContext context, Map<String, dynamic> story) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(story['title'] ?? 'Story'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story['description'] ?? 'No description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (story['date'] != null)
                Text(
                  'Posted: ${story['date']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event['title'] ?? 'Event'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['description'] ?? 'No description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (event['date'] != null) _detailItem('Date', event['date']),
              if (event['time'] != null) _detailItem('Time', event['time']),
              const SizedBox(height: 16),
              if (event['createdAt'] != null)
                Text(
                  'Created: ${event['createdAt']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
