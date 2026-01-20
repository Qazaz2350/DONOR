// Add your donor/orphanage pages
import 'package:donate/COMMOM/button.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/login/signup.dart';
import 'package:donate/VIEWMODEL/auth/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignInScreenView extends StatelessWidget {
  const SignInScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: context.colors.surface,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: vm.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 60.h),
                      Image.asset('assets/icons/blackbox.png', height: 100.h),
                      SizedBox(height: 30.h),

                      // Title
                      RichText(
                        text: TextSpan(
                          text: "Welcome back, ",
                          style: context.text.headlineLarge?.copyWith(
                            color: context.colors.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: 'sign in!',
                              style: context.text.headlineLarge?.copyWith(
                                color: context.colors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),

                      Text(
                        "Enter your details to continue",
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Email
                      TextFormField(
                        controller: vm.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          context,
                          'Enter Email Address',
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Password
                      TextFormField(
                        controller: vm.passwordController,
                        obscureText: !vm.isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          context,
                          'Enter Password',
                          isPassword: true,
                          isPasswordVisible: vm.isPasswordVisible,
                          toggleVisibility: vm.togglePasswordVisibility,
                        ),
                      ),
                      // SizedBox(height: 16.h),

                      // Dropdown for user type
                      // DropdownButtonFormField<String>(
                      //   value: vm.userType,
                      //   items: const [
                      //     DropdownMenuItem(
                      //       value: 'donor',
                      //       child: Text('Donor'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: 'orphanage',
                      //       child: Text('Orphanage'),
                      //     ),
                      //   ],
                      //   decoration: InputDecoration(
                      //     hintText: 'Select Account Type',
                      //     hintStyle: context.text.bodyMedium?.copyWith(
                      //       color: context.colors.onSurface.withOpacity(0.5),
                      //       fontSize: FontSizes.f14,
                      //     ),
                      //     filled: true,
                      //     fillColor: context.colors.surface,
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12.r),
                      //     ),
                      //     contentPadding: EdgeInsets.symmetric(
                      //       horizontal: 20.w,
                      //       vertical: 13.h,
                      //     ),
                      //   ),
                      //   onChanged: (value) {
                      //     vm.setUserType(value!);
                      //   },
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please select account type';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      SizedBox(height: 24.h),

                      // Sign In Button
                      PrimaryButton(
                        text: 'Sign In',
                        onPressed: () async {
                          await vm.signIn(context);
                        },
                      ),

                      SizedBox(height: 24.h),
                      // OR Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: context.colors.onSurface.withOpacity(0.2),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'OR',
                              style: context.text.bodyMedium?.copyWith(
                                color: context.colors.onSurface.withOpacity(
                                  0.7,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: context.colors.onSurface.withOpacity(0.2),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: context.text.bodyMedium?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () {
                              Nav.push(context, const SignUpScreenView());
                            },
                            child: Text(
                              'Sign Up Here',
                              style: context.text.bodyMedium?.copyWith(
                                color: context.colors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String hint, {
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: context.text.bodyMedium?.copyWith(
        color: context.colors.onSurface.withOpacity(0.5),
        fontSize: FontSizes.f14,
      ),
      filled: true,
      fillColor: context.colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: context.colors.onSurface.withOpacity(0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: context.colors.onSurface.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: context.colors.primary, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: context.colors.onSurface.withOpacity(0.7),
                size: 22.sp,
              ),
              onPressed: toggleVisibility,
            )
          : null,
    );
  }
}
