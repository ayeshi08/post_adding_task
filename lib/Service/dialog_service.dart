import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appStyle/appColor.dart';

String enteredText1 = "";
String enteredText2 = "";
Future<void> sshowDialog(BuildContext context) async {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    //isScrollControlled: true,// user must tap a button to close the dialog
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SingleChildScrollView(
          child: Container(
            width: 400.w,
            height: 900.h,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Insert Data',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  10.verticalSpace,
                  TextFormField(
                    controller: controller1,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.w),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.HeadingTextColor),
                      ),
                      hintText: ' Enter Title Here',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                        fontFamily: 'Poppins-Black',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        //  color: head
                      ),
                    ),
                  ),
                  28.verticalSpace,
                  TextFormField(
                      maxLength: 1000,
                      controller: controller2,
                      maxLines: 12,
                      // //
                      minLines: 5,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 2.w),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.HeadingTextColor),
                        ),
                        hintText: ' Enter the Description',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontFamily: 'Poppins-Black',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  20.verticalSpace,
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the dialog without saving
                          },
                        ),
                        TextButton(
                            child: Text('Add Data'),
                            onPressed: () async {
                              // Get the current user
                              User? user = FirebaseAuth.instance.currentUser;
                              // Store the entered text from the text fields
                              enteredText1 = controller1.text;
                              enteredText2 = controller2.text;

                              // Check if the user is signed in
                              if (user != null) {
                                final userDoc = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get();
                                if (!userDoc.exists) {
                                  // Handle the case where the user document does not exist
                                  print('User document not found');
                                  return;
                                }
                                final String userName = userDoc[
                                    'name']; // Fetch name from user document

                                // Store data in Firestore
                                FirebaseFirestore.instance
                                    .collection('posts')
                                    .add({
                                  'text1': enteredText1,
                                  'text2': enteredText2,
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'userName':
                                      userName, // This sets the current server timestamp
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Center(
                                    child: Text(
                                      'Post Added',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  backgroundColor: Colors.black,
                                ));
                                // Close the dialog box after submitting
                                Navigator.of(context).pop();
                              } else {
                                // Handle user not logged in
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Center(
                                    child: Text(
                                      'User not logged in!',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                ));
                              }
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
