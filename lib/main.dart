import 'package:cord/traveler/home.dart';
import 'package:cord/user/Reqparcel.dart';
import 'package:cord/user/Reqride.dart';
import 'package:cord/user/givefdbk.dart';
import 'package:cord/user/home.dart';
import 'package:cord/user/loginpage.dart';
import 'package:cord/user/nrsttrvelers.dart';
import 'package:cord/user/reg.dart';
import 'package:cord/user/sendcomplaints.dart';
import 'package:cord/user/trackride.dart';
import 'package:cord/traveler/viewfeedback.dart';
import 'package:cord/user/viewtravelroute.dart';
import 'package:cord/traveler/viewearnings.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:Loginscreen()

    );
  }
}
