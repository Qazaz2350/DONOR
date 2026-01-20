import 'package:donate/MODELS/SCREENS/ADMIN/admin_dashboard_model.dart';
import 'package:flutter/material.dart';

class AdminOrphanageViewModel extends ChangeNotifier {
  bool loading = false;
  List<OrphanageModel> orphanages = [];

  // Fake fetch - replace with Firestore in real app
  Future<void> fetchOrphanages() async {
    loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    orphanages = [
      OrphanageModel(
        id: '1',
        name: 'Sunshine Orphanage',
        address: 'Street 123, City',
        verificationStatus: 'pending',
        cnicImage: 'https://via.placeholder.com/150',
        registrationDoc: 'https://via.placeholder.com/150',
        signboardImage: 'https://via.placeholder.com/150',
        orphanageImages: [
          'https://via.placeholder.com/100',
          'https://via.placeholder.com/100',
        ],
      ),
      OrphanageModel(
        id: '2',
        name: 'Hope Home',
        address: 'Street 456, City',
        verificationStatus: 'approved',
        cnicImage: 'https://via.placeholder.com/150',
        registrationDoc: 'https://via.placeholder.com/150',
        signboardImage: 'https://via.placeholder.com/150',
        orphanageImages: ['https://via.placeholder.com/100'],
      ),
    ];

    loading = false;
    notifyListeners();
  }

  Future<void> approveOrphanage(String id) async {
    orphanages = orphanages.map((o) {
      if (o.id == id) {
        return OrphanageModel(
          id: o.id,
          name: o.name,
          address: o.address,
          verificationStatus: 'approved',
          cnicImage: o.cnicImage,
          registrationDoc: o.registrationDoc,
          signboardImage: o.signboardImage,
          orphanageImages: o.orphanageImages,
        );
      }
      return o;
    }).toList();
    notifyListeners();
  }

  Future<void> rejectOrphanage(String id) async {
    orphanages = orphanages.map((o) {
      if (o.id == id) {
        return OrphanageModel(
          id: o.id,
          name: o.name,
          address: o.address,
          verificationStatus: 'rejected',
          cnicImage: o.cnicImage,
          registrationDoc: o.registrationDoc,
          signboardImage: o.signboardImage,
          orphanageImages: o.orphanageImages,
        );
      }
      return o;
    }).toList();
    notifyListeners();
  }
}
