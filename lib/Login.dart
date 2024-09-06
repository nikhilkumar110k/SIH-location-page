import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'SignUpPage.dart';
import 'UserModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      const snackbar = SnackBar(content: Text("Please fill all the values"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      logiIn(email, password);
    }
  }

  logiIn(String email, String password) async {
    UserCredential? credential;
    try {

        credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      var snackbar = SnackBar(content: Text(ex.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    if(credential!.user!.emailVerified){
      if (credential != null) {
        String uid = credential.user!.uid;
        DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
        UserModel userModel =
        UserModel.fromMap(userData.data() as Map<String, dynamic>);
        var snackbar = const SnackBar(content: Text("Sucessfully made the login!"));
        Navigator.push(context,  MaterialPageRoute(builder: (context) => SignUpPage(),));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      if(credential.user!.isAnonymous){
        AlertDialog alertbox= AlertDialog(
          title: const Text("Please verify your gmailID"),
          actions:
          <Widget>[
            TextButton(onPressed: ()async{

            }, child: const Text("Ok"),),
            TextButton(onPressed: (){
              exit(0);
            }, child: const Text("Leave the App"))
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertbox;
          },
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/Illustration.png',
                width: double.infinity,
                height: 177,
              ),
              SizedBox(height: 20),
              Text(
                'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        color: Colors.white,
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: Theme.of(context).textTheme.labelMedium,
                            contentPadding: const EdgeInsets.all(10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        color: Colors.white,
                        child: TextField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: Theme.of(context).textTheme.labelMedium,
                            contentPadding: const EdgeInsets.all(10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 20,),

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      checkValues();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't Have An Account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
                child: const Text("Sign Up"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const SignUpPage();
                    }),
                  );
                })
          ],
        ),
      ),
    );
  }
}

