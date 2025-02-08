import 'package:cloud_firestore/cloud_firestore.dart';
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
    barrierDismissible: false, // user must tap a button to close the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: Container(
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
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without saving
            },
          ),
          TextButton(
            child: Text('Add Data'),
            onPressed: () async {
              // Store the entered text from the text fields
              enteredText1 = controller1.text;
              enteredText2 = controller2.text;

              // Store data in Firestore
              FirebaseFirestore.instance.collection('newData').add({
                'text1': enteredText1,
                'text2': enteredText2,
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Center(
                  child: Text(
                    'Post Added',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                backgroundColor: Colors.transparent,
              ));
              // Close the dialog box after submitting
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },

  );
}
