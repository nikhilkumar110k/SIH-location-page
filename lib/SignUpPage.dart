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
  String? employeeSecret;
  String? message;
  String? employeeid;
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
    }
  }

  Future<void> employeeidandsecret() async {
    try {
      Uri uri = Uri.parse('https://spotsync.tg-tool.tech/api/verify');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "employeeId": userId.text
        }),
      );

      print("Request URL: $uri");
      print("Request Body: ${jsonEncode({"employeeId": userId.text})}");
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print('API worked!');
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody["message"] == "Employee found") {
          print("Employee found");

          final Map<String, dynamic> data = responseBody['body'];
          setState(() {
            employeeSecret = data["employeeSecret"];
            employeeid = data["employeeId"];
          });

          print("employeeSecret: $employeeSecret");
          print("employeeId: $employeeid");

          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          print('Employee not found');
        }
      } else {
        throw Exception('Failed to load the entries. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching API: $e");
    }
  }

  Future<void> _saveData() async {
    await employeeidandsecret(); // Ensure this completes first

    final url = Uri.parse('https://team007-dc442.firebaseio.com/userdata.json');

    try {
      print("employeeSecret: $employeeSecret");
      print("employeeidfrombackend: $employeeid");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'employeesecret': employeeSecret,
          'employeeidfrombackend': employeeid,
          'email': emailController.text,
        }),
      );

      print("Save Request URL: $url");
      print("Save Request Body: ${json.encode({
        'employeesecret': employeeSecret,
        'employeeidfrombackend': employeeid,
        'email': emailController.text,
      })}");
      print("Save Response Status Code: ${response.statusCode}");
      print("Save Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Saved!')),
        );
      } else {
        throw Exception('Failed to save Data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error saving data: $error");
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
                  height: 165,
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
