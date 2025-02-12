import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_task/appStyle/appColor.dart';
import 'package:new_task/providers/auth_provider.dart';
import 'package:new_task/screen/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/textcontroller_provider.dart';
import '../providers/password_visibility_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final namecontroller =
        Provider.of<TextEditingControllerProvider>(context).namecontroller;
    final TextEditingController emailcontroller = TextEditingController();

    TextEditingController passwordcontroller = TextEditingController();

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
                  controller: namecontroller,
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.account_box),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.HeadingTextColor),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      labelText: ' User Name',
                      labelStyle: TextStyle(
                        color: Colors.black45,
                        fontFamily: 'Poppins-Black',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                20.verticalSpace,
                TextFormField(
                  key: ValueKey('email'),
                  controller: emailcontroller,
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.HeadingTextColor),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      labelText: ' Email',
                      labelStyle: TextStyle(
                        color: Colors.black45,
                        fontFamily: 'Poppins-Black',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      )),
                  validator: (value) {
                    if (!(value.toString().contains('@'))) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Incorrect Email',
                          style: TextStyle(color: AppColors.appMainColor),
                        ),
                        backgroundColor: Colors.black,
                      ));
                    } else {
                      return null;
                    }
                  },
                ),
                20.verticalSpace,
                Consumer<PasswordVisibility>(
                    builder: (context, passwordVisibilityProvider, child) {
                  return TextFormField(
                      controller: passwordcontroller,
                      obscureText:
                          !passwordVisibilityProvider.isPasswordVisible,
                      decoration: new InputDecoration(
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
                        ),
                      ));
                }),
                18.verticalSpace,
                InkWell(
                  onTap: () async {
                    final String email = emailcontroller.text;
                    final String password = passwordcontroller.text;
                    final String username = namecontroller.text;
                    if (email.isEmpty || password.isEmpty || username.isEmpty) {
                      // Show a SnackBar if either field is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please fill all the fields.',
                            style: TextStyle(color: AppColors.appMainColor),
                          ),
                          backgroundColor: Colors.black,
                        ),
                      );
                    }
                    final authService = Provider.of<AuthenticationService>(
                        context,
                        listen: false);
                    final user = await authService.registerWithEmailPassword(
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
                      'Sign Up',
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
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.black45,
                          )),
                      TextSpan(
                          text: 'Login',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Poppins-Black',
                              fontSize: 14.sp),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(LoginScreen());
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
