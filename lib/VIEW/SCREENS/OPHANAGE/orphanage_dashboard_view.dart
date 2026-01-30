import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_home/orphanage_home_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanagecallreeq/orphanage_callreq_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/profile/orphanageProfileView.dart';
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
  final List<String> _titles = [
    'Home Dashboard',
    'Call Requests',
    'Create Request',
    // 'Profile',
  ];

  @override
  void initState() {
    super.initState();
    // Length should match tabs count (4)
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
            // drawer: _buildDrawer(vm),
            appBar: AppBar(
              centerTitle: true, // Center the title
              title: Text(
                _titles[_tabController.index],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                Text("data"),

                // Tab 3: Create Request
                OrphanageRequestView(),
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
                  Tab(icon: Icon(Icons.add_box), text: 'Create'),
                  // Tab(icon: Icon(Icons.person), text: 'Profile'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
