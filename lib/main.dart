import 'package:donate/VIEW/SCREENS/DONOR/sender_view.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';

import 'package:donate/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent
      statusBarIconBrightness: Brightness.dark, // Android icons (light bg)
      statusBarBrightness: Brightness.light, // iOS
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Donorviewmodel())],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // your design reference
        minTextAdapt: true, // ✅ prevents LateInitializationError
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system, // aut
            home: const SenderView(),
          );
        },
      ),
    );
  }
}
