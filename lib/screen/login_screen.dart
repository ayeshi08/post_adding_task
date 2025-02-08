import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_task/appStyle/appColor.dart';
import 'package:new_task/screen/signUp_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/password_visibility_provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  // homeController controller = Get.put(homeController());

  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();
  bool loading = false;
// signIn()async{
//   await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appMainColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 50.h),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                    radius: 45.sp,
                    child: Image(image: AssetImage('assets/images/user.png'))),
                25.verticalSpace,
                TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.w),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.HeadingTextColor),
                      ),
                      labelText: ' Email',
                      labelStyle: TextStyle(
                        color: Colors.black45,
                        fontFamily: 'Poppins-Black',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      )),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Fill all Fields',
                          style: TextStyle(color: AppColors.appMainColor),
                        ),
                        backgroundColor: AppColors.TextColor,
                      ));
                    }
                    //email format validation
                    String emailPattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                    RegExp regExp = RegExp(emailPattern);
                    if (!regExp.hasMatch(value!)) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),
                20.verticalSpace,
                Consumer<PasswordVisibility>(
                    builder: (context, passwordVisibilityProvider, child) {
                  return TextFormField(
                    controller: passwordcontroller,
                    obscureText: !passwordVisibilityProvider.isPasswordVisible,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 2.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.HeadingTextColor),
                        ),
                        labelText: ' Password',
                        labelStyle: TextStyle(
                          color: Colors.black45,
                          fontFamily: 'Poppins-Black',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          //  color: head
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisibilityProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Toggle password visibility
                            passwordVisibilityProvider
                                .togglePasswordVisibility();
                          },
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  );
                }),
                18.verticalSpace,
                GestureDetector(
                  onTap: () async {
                    final String email = emailcontroller.text;
                    final String password = passwordcontroller.text;
                    if (email.isEmpty || password.isEmpty) {
                      // Show a SnackBar if either field is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please enter both email and password.',
                            style: TextStyle(color: AppColors.appMainColor),
                          ),
                          backgroundColor: Colors.black,
                        ),
                      );
                    }

                    final authService = Provider.of<AuthenticationService>(
                        context,
                        listen: false);
                    final user = await authService.signInWithEmailPassword(
                        email, password, context);
                  },
                  child: Container(
                    width: 170.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: AppColors.appSecondaryColor,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                    ),
                    child: Center(
                        child: Text(
                      'Log In',
                      style: TextStyle(
                          fontFamily: 'Poppins-Black',
                          fontSize: 14.sp,
                          color: AppColors.appMainColor),
                    )),
                  ),
                ),
                20.verticalSpace,
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-Black',
                        fontSize: 14.sp),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Dont have an account? ',
                          style: TextStyle(
                            color: Colors.black45,
                          )),
                      TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Poppins-Black',
                              fontSize: 14.sp),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(SignupScreen());
                            }),
                    ],
                  ),
                ),
                10.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
