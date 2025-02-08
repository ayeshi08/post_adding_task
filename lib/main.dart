import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_task/providers/auth_provider.dart';
import 'package:new_task/providers/password_visibility_provider.dart';

import 'package:new_task/wrapper.dart';
import 'package:provider/provider.dart';


void main() async{
  await
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationService()), // First provider
        ChangeNotifierProvider(create: (_) => PasswordVisibility()), // Second provider
      ],
    child:   MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      ScreenUtilInit(

        designSize: Size (360, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) =>
    //ChangeNotifierProvider(create: (BuildContext context)=>AuthenticationService(), child:
      GetMaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:
      Wrapper(),
      )
      ///)
    );
  }
}
