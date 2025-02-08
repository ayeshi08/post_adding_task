
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_task/Service/dialog_service.dart';
import 'package:provider/provider.dart';
import '../Service/firebase_service.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class NewHome extends StatefulWidget {
  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationService>(
      builder: (context, authService, child) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Transform.scale( scale: 0.3,
                    child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
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
                            onPressed: () => sshowDialog(context),
                                //_showDialog(context),
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
