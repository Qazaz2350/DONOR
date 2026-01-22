import 'package:donate/COMMOM/button.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/login/signin_view.dart';
import 'package:donate/VIEWMODEL/auth/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:donate/UTILIS/app_fonts.dart';

class SignUpScreenView extends StatelessWidget {
  const SignUpScreenView({Key? key}) : super(key: key);

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

                      Image.asset('assets/icons/Polygon 1.png', height: 100.h),
                      SizedBox(height: 30.h),

                      // Title
                      RichText(
                        text: TextSpan(
                          text: "Let's get you ",
                          style: context.text.headlineLarge?.copyWith(
                            color: context.colors.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: 'started!',
                              style: context.text.headlineLarge?.copyWith(
                                color: context.colors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Subtitle
                      Text(
                        "Let's help create an account",
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurface.withOpacity(0.7),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // Full Name
                      TextFormField(
                        controller: vm.fullNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(context, 'Enter Fullname'),
                      ),

                      SizedBox(height: 16.h),
                      // Add inside the Column, before the Full Name TextFormField
                      SizedBox(height: 16.h),

                      // User Type Dropdown
                      DropdownButtonFormField<String>(
                        value: vm.userType, // this will come from ViewModel
                        items: const [
                          DropdownMenuItem(
                            value: 'donor',
                            child: Text('Donor'),
                          ),
                          DropdownMenuItem(
                            value: 'orphanage',
                            child: Text('Register as Orphanage'),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Select Account Type',
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
                            borderSide: BorderSide(
                              color: context.colors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 13.h,
                          ),
                        ),
                        onChanged: (value) {
                          vm.setUserType(value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select account type';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Add this inside the Column, probably after Full Name, before User Type Dropdown
                      SizedBox(height: 16.h),

                      // Phone Number
                      TextFormField(
                        controller: vm.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          final phoneRegex = RegExp(
                            r'^[0-9]{10,15}$',
                          ); // Adjust as per format
                          if (!phoneRegex.hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          context,
                          'Enter Phone Number',
                        ),
                      ),

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

                      SizedBox(height: 24.h),

                      // Sign Up Button
                      PrimaryButton(
                        text: 'Sign Up',
                        onPressed: () {
                          vm.signUp(context);
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

                      SizedBox(height: 24.h),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Have Account?',
                            style: context.text.bodyMedium?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () {
                              Nav.push(context, SignInScreenView());
                            },
                            child: Text(
                              'Login Here',
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
