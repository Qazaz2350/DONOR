import 'package:donate/VIEW/SCREENS/DONOR/HOME/Home_view.dart';
import 'package:donate/VIEW/SCREENS/DONOR/donor_tabbar_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_Form_view.dart';
import 'package:donate/VIEW/SCREENS/OPHANAGE/orphanage_dashboard_view.dart';
import 'package:donate/VIEW/login/signin_view.dart';
import 'package:donate/VIEW/login/signup.dart';
import 'package:donate/VIEWMODEL/SCREENS/ORPHANAGE/Orphanage_View_Model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:donate/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DonorViewModel()),
        ChangeNotifierProvider(create: (_) => OrphanageViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: const SignUpScreenView(), // unified signup screen
          );
        },
      ),
    );
  }
}
