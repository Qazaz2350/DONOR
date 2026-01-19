import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_Form_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/orphanage_view_model.dart';
import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/UTILIS/app_fonts.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/request_view.dart';

class OrphanageDashboardView extends StatefulWidget {
  const OrphanageDashboardView({super.key});

  @override
  State<OrphanageDashboardView> createState() => _OrphanageDashboardViewState();
}

class _OrphanageDashboardViewState extends State<OrphanageDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _titles = [
    'Dashboard',
    'Create Request',
    'History',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrphanageViewModel()
        ..loadDashboardData()
        ..loadRequests(),
      child: Consumer<OrphanageViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            drawer: _buildDrawer(vm),
            appBar: AppBar(
              title: Text(_titles[_tabController.index]),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.home, color: Colors.white),
                  ),
                ),
              ],
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                // home
                _dashboardView(vm),

                // create PROFILE
                OrphanageRequestView(),

                // history
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _donationHistoryAndAnalytics(vm),
                ),

                // register
                OrphanageSignupView(),
              ],
            ),
            bottomNavigationBar: Material(
              color: AppColors.primary,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(icon: Icon(Icons.dashboard), text: 'Home'),
                  Tab(icon: Icon(Icons.add_box), text: 'Create'),
                  Tab(icon: Icon(Icons.history), text: 'History'),
                  Tab(icon: Icon(Icons.app_registration), text: 'Register'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// ================= DRAWER =================
  Widget _buildDrawer(OrphanageViewModel vm) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              vm.nameController.text.isEmpty
                  ? 'Orphanage'
                  : vm.nameController.text,
            ),
            accountEmail: Text(vm.emailController.text),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.home, color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(vm.phoneController.text),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(vm.addressController.text),
          ),
          ListTile(
            leading: Icon(vm.isVerified ? Icons.verified : Icons.pending),
            title: Text(vm.isVerified ? 'Verified' : 'Pending Verification'),
          ),
        ],
      ),
    );
  }

  /// ================= DASHBOARD =================
  Widget _dashboardView(OrphanageViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: FontSizes.f16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _infoCard('Total Required', 'Rs ${vm.totalRequiredDonation.toInt()}'),
          _infoCard(
            'Received',
            'Rs ${vm.totalReceivedDonation.toInt()}',
            color: Colors.green,
          ),
          _infoCard(
            'Remaining',
            'Rs ${vm.remainingDonation.toInt()}',
            color: Colors.red,
          ),
          const SizedBox(height: 12),
          Text(
            'Donation Progress',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          LinearProgressIndicator(
            value: vm.donationProgress,
            minHeight: 10,
            color: AppColors.primary,
            backgroundColor: Colors.grey.shade300,
          ),
          const SizedBox(height: 6),
          Text('${(vm.donationProgress * 100).toInt()}% completed'),
          const SizedBox(height: 12),
          Text('Pending Needs', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _needTile('Food', vm.foodRemaining),
          _needTile('Clothes', vm.clothesRemaining),
          _needTile('Education', vm.educationPending),
          if (vm.isUrgent)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Urgent Needs'),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Text('Impact', style: TextStyle(fontWeight: FontWeight.w600)),
          Text(
            'Children Benefited This Month: ${vm.childrenBenefitedThisMonth}',
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: FontSizes.f20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _needTile(String title, int value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          '$value remaining',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  /// ================= HISTORY + ANALYTICS =================
  Widget _donationHistoryAndAnalytics(OrphanageViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Donation History',
          style: TextStyle(
            fontSize: FontSizes.f16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.requests.length,
          itemBuilder: (_, i) {
            final req = vm.requests[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(req.type),
                subtitle: Text(
                  'Qty: ${req.requiredQuantity} | Status: ${req.status}',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Impact Analytics',
          style: TextStyle(
            fontSize: FontSizes.f16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Total Donations Received: Rs ${vm.totalReceivedDonation.toInt()}',
        ),
        Text('Children Benefited This Month: ${vm.childrenBenefitedThisMonth}'),
        Text('Remaining Food Packs: ${vm.foodRemaining}'),
        Text('Remaining Clothes Sets: ${vm.clothesRemaining}'),
        Text('Pending Education Sponsorship: ${vm.educationPending}'),
      ],
    );
  }

  /// ================= PROFILE =================
  Widget _profileForm(OrphanageViewModel vm) => Column(
    children: [
      TextFormField(
        controller: vm.nameController,
        decoration: const InputDecoration(labelText: 'Name'),
      ),
      TextFormField(
        controller: vm.emailController,
        decoration: const InputDecoration(labelText: 'Email'),
      ),
      TextFormField(
        controller: vm.phoneController,
        decoration: const InputDecoration(labelText: 'Phone'),
      ),
      TextFormField(
        controller: vm.addressController,
        decoration: const InputDecoration(labelText: 'Address'),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Update Profile'),
        ),
      ),
    ],
  );
}
