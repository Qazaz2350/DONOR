import 'package:donate/COMMOM/button.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEWMODEL/auth/signin_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:donate/UTILIS/app_fonts.dart';

class SignInScreenView extends StatelessWidget {
  const SignInScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: Consumer<SignInViewModel>(
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

                      // Logo / Polygon
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

                      // Subtitle
                      Text(
                        "Enter your details to continue",
                        style: context.text.bodyMedium?.copyWith(
                          color: context.colors.onSurface.withOpacity(0.7),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // Email TextFormField
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

                      // Password TextFormField
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

                      // Sign In Button
                      PrimaryButton(
                        text: 'Sign In',
                        onPressed: () => vm.signIn(context),
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

                      // Register Link
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
                              Nav.pop(context);
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
