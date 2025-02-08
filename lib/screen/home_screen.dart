import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../appStyle/appColor.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class NewHome extends StatefulWidget {
  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  String enteredText1 = "";
  String enteredText2 = "";
  Future<void> _showDialog(BuildContext context) async {
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
            width: 360.w,
            height: 812.h,
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
  // Function to show the dialog

  // Function to get data from Firebase Firestore
  Stream<List<Map<String, dynamic>>> getDataFromFirestore() {
    return FirebaseFirestore.instance
        .collection('newData')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => {
      'text1': doc['text1'],
      'text2': doc['text2'],
    })
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationService>(
      builder: (context, authService, child) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child:
                Transform.scale( scale: 0.3,
                    child: CircularProgressIndicator())),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (snapshot.hasData) {
              // User is signed in
              return Scaffold(
                appBar: AppBar(backgroundColor: Colors.blueAccent,
                  title: Text('HomeScreen'
                    //  '${snapshot.data!.email}'
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        authService.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      20.verticalSpace,
                      // StreamBuilder to display data from Firebase Firestore
                      Expanded(
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: getDataFromFirestore(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Transform.scale(
                                  scale: 0.2,
                                  child:

                                  CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text("No data available.");
                            }

                            // Display the data from Firestore
                            final data = snapshot.data!;

                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];
                                return ListTile(
                                  title: Text(
                                    "${item['text1']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueAccent),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item['text2']}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.w, vertical: 25.h),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            onPressed: () => _showDialog(context),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
            // }
          },
        );
      },
    );
  }
}
