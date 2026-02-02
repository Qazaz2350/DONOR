// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class testing extends StatefulWidget {
//   const testing({super.key});

//   @override
//   State<testing> createState() => _testingState();
// }

// class _testingState extends State<testing> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late Future<List<Map<String, dynamic>>> _orphanagesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _orphanagesFuture = fetchAcceptedOrphanages();
//   }

//   Future<List<Map<String, dynamic>>> fetchAcceptedOrphanages() async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('orphanage')
//           .where('status', isEqualTo: 'accepted')
//           .get();

//       return snapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         data['uid'] = doc.id;
//         return data;
//       }).toList();
//     } catch (e) {
//       debugPrint('Error fetching orphanages: $e');
//       return [];
//     }
//   }

//   Widget buildCard(Map<String, dynamic> orphanage) {
//     // Combine all images
//     List<String> allImages = [];
//     if (orphanage['cnicImage'] != null) allImages.add(orphanage['cnicImage']);
//     if (orphanage['signBoardImage'] != null)
//       allImages.add(orphanage['signBoardImage']);
//     if (orphanage['orphanageImage'] != null)
//       allImages.add(orphanage['orphanageImage']);
//     if (orphanage['additionalImages'] != null)
//       allImages.addAll(List<String>.from(orphanage['additionalImages']));

//     // Safe casting
//     final needsList = (orphanage['needs'] ?? []) as List<dynamic>;
//     final storiesList = (orphanage['stories'] ?? []) as List<dynamic>;
//     final eventsList = (orphanage['volunteeringEvents'] ?? []) as List<dynamic>;

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               orphanage['orphanagename'] ?? orphanage['name'] ?? 'No Name',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Text('Email: ${orphanage['email'] ?? '-'}'),
//             Text('Phone: ${orphanage['phone'] ?? '-'}'),
//             Text(
//               'Address: ${orphanage['orphanageaddress'] ?? orphanage['address'] ?? '-'}',
//             ),
//             Text('CNIC: ${orphanage['cnic'] ?? '-'}'),
//             Text('Verified: ${orphanage['verified'] == true ? "Yes" : "No"}'),
//             Text('Status: ${orphanage['status'] ?? '-'}'),
//             const SizedBox(height: 8),

//             // Images
//             if (allImages.isNotEmpty)
//               SizedBox(
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: allImages.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: Image.network(
//                         allImages[index],
//                         width: 100,
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             const SizedBox(height: 8),

//             // Needs
//             if (needsList.isNotEmpty) Text('Needs: ${needsList.join(', ')}'),

//             // Stories
//             if (storiesList.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               const Text(
//                 'Stories:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               for (var s in storiesList)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 2),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Title: ${(s as Map<String, dynamic>)['title'] ?? ''}',
//                       ),
//                       Text('Description: ${s['description'] ?? ''}'),
//                     ],
//                   ),
//                 ),
//             ],

//             // Volunteering Events
//             if (eventsList.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               const Text(
//                 'Volunteering Events:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               for (var v in eventsList)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 2),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Name: ${(v as Map<String, dynamic>)['name'] ?? ''}',
//                       ),
//                       Text('Date: ${v['date'] ?? ''}'),
//                     ],
//                   ),
//                 ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Accepted Orphanages')),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _orphanagesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final orphanages = snapshot.data ?? [];

//           if (orphanages.isEmpty) {
//             return const Center(child: Text('No accepted orphanages found.'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: orphanages.length,
//             itemBuilder: (context, index) {
//               return buildCard(orphanages[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
