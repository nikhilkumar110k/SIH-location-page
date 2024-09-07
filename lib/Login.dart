import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'SignUpPage.dart';
import 'loginandsigninredirector.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> removeInvalidUsers() async {
    final url = Uri.parse('https://team007-dc442.firebaseio.com/userdata.json');

    try {
      final response = await http.get(url);
      print("Fetch Response Status Code: ${response.statusCode}");
      print("Fetch Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> allUsers = json.decode(response.body);

        for (var userId in allUsers.keys) {
          final userData = allUsers[userId];
          if (userData['employeeidfrombackend'] == null || userData['employeesecret'] == null) {
            await _removeUser(userId);
            _logoutUser();
          }
          if (userData['employeeidfrombackend'] != null || userData['employeesecret'] != null) {
            checkValues();
          }
        }
      } else {
        throw Exception('Failed to fetch users. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void _logoutUser() {
    FirebaseAuth.instance.signOut().then((_) {
      print("User logged out successfully");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginandSignPage()));
    }).catchError((error) {
      print("Error logging out: $error");
    });
  }

  Future<void> _removeUser(String userId) async {
    final deleteUrl = Uri.parse('https://team007-dc442.firebaseio.com/userdata/$userId.json');

    try {
      final response = await http.delete(deleteUrl);

      if (response.statusCode == 200) {
        print("User data removed successfully");
      } else {
        throw Exception('Failed to remove user data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error removing user data: $error");
    }
  }

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      const snackbar = SnackBar(content: Text("Please fill all the values"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      logiIn(email, password);
    }
  }

  Future<void> logiIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        if (credential.user!.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully logged in!"))
          );

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Homepage())
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please verify your email!"))
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed."))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );
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
                'Enter The Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

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
                      removeInvalidUsers();
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
        color: Colors.white,
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
