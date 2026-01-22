import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  /// Fetch signup orphanages
  Future<List<Map<String, dynamic>>> fetchSignUpOrphanages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orphanage')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map(
          (doc) => {
            'id': doc.id,
            'type': 'signup',
            ...doc.data() as Map<String, dynamic>,
          },
        )
        .toList();
  }

  /// Fetch OFFD orphanages
  Future<List<Map<String, dynamic>>> fetchOffdOrphanages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('offdOrphanage') // replace with your actual collection name
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map(
          (doc) => {
            'id': doc.id,
            'type': 'official',
            ...doc.data() as Map<String, dynamic>,
          },
        )
        .toList();
  }

  /// Combine both lists
  Future<List<Map<String, dynamic>>> fetchAllOrphanages() async {
    final signup = await fetchSignUpOrphanages();
    final offd = await fetchOffdOrphanages();
    return [...signup, ...offd];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Orphanages')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllOrphanages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orphanages = snapshot.data;
          if (orphanages == null || orphanages.isEmpty) {
            return const Center(child: Text('No orphanages found.'));
          }

          return ListView.builder(
            itemCount: orphanages.length,
            itemBuilder: (context, index) {
              final orphanage = orphanages[index];
              final isSignup = orphanage['type'] == 'signup';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(orphanage['fullName'][0])),
                  title: Text(orphanage['fullName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${orphanage['email']}'),
                      Text('Phone: ${orphanage['phone']}'),
                      if (!isSignup)
                        Text('Address: ${orphanage['offd_address'] ?? '-'}'),
                      Text(
                        'Status: ${isSignup ? orphanage['status'] : orphanage['offd_status']}',
                      ),
                      if (!isSignup)
                        Text(
                          'Verified: ${orphanage['offd_verified'] == true ? "Yes" : "No"}',
                        ),
                    ],
                  ),
                  trailing: isSignup
                      ? const Text('Signup')
                      : const Text('Official'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
