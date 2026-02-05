import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/TABBAR/orphanage_home_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/TABBAR/orphanage_call_request_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/TABBAR/orphanage_sponserchid_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanageProfileView.dart';
import 'package:donate/VIEWMODEL/auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/orphanage_view_model.dart';
import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/request_view.dart';

class OrphanageDashboardView extends StatefulWidget {
  // final String fullname;
  // final String email;
  // final String phone;
  const OrphanageDashboardView({
    super.key,
    // required this.fullname,
    // required this.email,
    // required this.phone,
  });

  @override
  State<OrphanageDashboardView> createState() => _OrphanageDashboardViewState();
}

class _OrphanageDashboardViewState extends State<OrphanageDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Option 2: All 4 titles
  // final List<String> _titles = [
  //   'Home Dashboard',
  //   'Call Requests',
  //   'Create Request',
  //   // 'Profile',
  // ];

  @override
  void initState() {
    super.initState();
    // Length should match tabs count (4)
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrphanageViewModel(),
      child: Consumer<OrphanageViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            // drawer: _buildDrawer(vm),
            appBar: AppBar(
              title: const Text('Orphanage Dashboard'),
              centerTitle: true, // Center the title

              leadingWidth: 70, // Increase width to fit avatar nicely
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Nav.push(context, Orphanageprofileview());
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://example.com/avatar.jpg', // Replace with your image URL or AssetImage
                    ),
                  ),
                ),
              ),
            ),

            body: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Home
                OrphanageHomeView(),
                // Tab 2: Call Requests
                CallRequestView(),
                // Tab 3: Create Request
                OrphanageSponserchidView(),

                // Tab 3: Create Request
                Center(
                  child: ElevatedButton(
                    onPressed: () => Provider.of<AuthViewModel>(
                      context,
                      listen: false,
                    ).logout(context),
                    child: Text('Logout'),
                  ),
                ),
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
                  Tab(icon: Icon(Icons.home), text: 'Home'),
                  Tab(icon: Icon(Icons.video_call), text: 'Call Requests'),
                  Tab(icon: Icon(Icons.add_box), text: 'logout'),
                  Tab(icon: Icon(Icons.person), text: 'sponser Child'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
