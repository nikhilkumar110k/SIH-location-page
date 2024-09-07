import 'dart:convert';
import 'dart:io';
import 'UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login.dart';
import 'UserModel.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userId = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      const snackbar = SnackBar(content: Text("Please fill all the values"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      const snackbar = SnackBar(content: Text("Signup successful!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      signUp(email, password);
      AlertDialog alertbox= AlertDialog(
        title: const Text("Please Proceed to Login"),
        actions:
        <Widget>[
          TextButton(onPressed: ()async{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));

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

  void _saveData() async {

    final url = Uri.parse('');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'userId':userId.text
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Saved!')),
        );
      } else {
        throw Exception('Failed to save Data');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save Data')),
      );
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      var snackbar = SnackBar(content: Text(ex.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    if (credential != null) {
      credential.user?.sendEmailVerification();
      String uid = credential.user!.uid;
      UserModel newuser =
      UserModel(uid: uid, email: email, employeeid: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newuser.toMap())
          .then((value) => const SnackBar(content: Text("new user created")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 2),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: TextField(
                            controller: userId,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Enter User ID',
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Email Text',
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
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(15)
                          ),
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
                        _saveData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Create account', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already Have An Account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
                child: const Text("Login"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
