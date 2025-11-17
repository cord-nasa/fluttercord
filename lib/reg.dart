import 'package:cord/login.dart';
import 'package:flutter/material.dart'; 

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
TextEditingController name=TextEditingController();
TextEditingController phno=TextEditingController();
TextEditingController email=TextEditingController();
TextEditingController pswd=TextEditingController();
TextEditingController place=TextEditingController();
final formkey=GlobalKey<FormState>();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 248, 92),
        title: Text(
          'Registration',
          style: TextStyle(color: const Color.fromARGB(255, 167, 13, 214)),
        ),
      ),
      body: Form(key: formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller: name,
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    return 'Please enter your name';
                  }
                },
                decoration: InputDecoration(
                  label: Text('Name'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller:phno,
                validator:(value) {
                 if (value==null||value.isEmpty) {
                  return 'Please enter your phone number';
                 }
                 },
                decoration: InputDecoration(
                  label: Text('Phone.no'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller:email,
                validator:(value){
                  if(value==null||value.isEmpty){
                    return 'Please enter your email';
                  }
                },
                decoration: InputDecoration(
                  label: Text('Email'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller:place,
                validator:(value) {
                 if (value==null||value.isEmpty) {
                  return 'Please enter your Place';
                 }
                 },
                decoration: InputDecoration(
                  label: Text('Place'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller:pswd,
                validator:(value) {
                 if (value==null||value.isEmpty) {
                  return 'Please enter your Password';
                 }
                 },
                decoration: InputDecoration(
                  label: Text('Password'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {if (formkey.currentState!.validate()) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen(),));
                
              }},
              child: Text('Sign in', style: TextStyle(color: const Color.fromARGB(255, 22, 22, 22)),),
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 249, 249, 249)),
            ),
          ],
        ),
      ),
    );
  }
}
