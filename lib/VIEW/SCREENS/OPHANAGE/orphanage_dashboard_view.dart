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

  final List<String> _titles = ['Dashboard', 'Create Request', 'Profile'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrphanageViewModel(),
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
                // Home tab simplified
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Welcome, ${vm.nameController.text.isEmpty ? 'Orphanage' : vm.nameController.text}!',
                    style: TextStyle(
                      fontSize: FontSizes.f16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Create Request
                OrphanageRequestView(),

                // Profile / Signup
                // OrphanageFormView(),
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
                  Tab(icon: Icon(Icons.person), text: 'Profile'),
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
        ],
      ),
    );
  }
}
