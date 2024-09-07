import 'dart:convert';
import 'dart:typed_data' as typed_data;
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'config/Colors.dart';


class ProfileEdit1 extends StatefulWidget {
  const ProfileEdit1({super.key});

  @override
  State<ProfileEdit1> createState() => _ProfileEdit1State();
}
Future<String> convertFileToBase64(XFile file) async {
  typed_data.Uint8List fileBytes = await file.readAsBytes();
  return base64Encode(fileBytes);
}

class _ProfileEdit1State extends State<ProfileEdit1> {
  XFile? imageFile;
  String? base64Image;

  TextEditingController mobileNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pinCode = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<String> convertFileToBase64(XFile file) async {
    typed_data.Uint8List fileBytes = await file.readAsBytes();
    return base64Encode(fileBytes);
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  // Sanitize the email to use as Firebase key
  String sanitizeEmail(String email) {
    return email.replaceAll('.', ',');
  }

  Future<void> editYourBasicDetails() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String email = user.email ?? '';
        String sanitizedEmail = sanitizeEmail(email);

        Map<String, dynamic> data = {
          "profilePicture": base64Image ?? '',
          "mobileNumber": mobileNumber.text,
          "addressLine1": address.text,
          "city": city.text,
          "state": state.text,
          "pinCode": pinCode.text,
        };

        await _database.child("userdata/$sanitizedEmail").update(data);

        print("User profile updated successfully!");
      } else {
        print("User not authenticated");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
        body:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Profile",
                  style:Theme.of(context).textTheme.headlineMedium,
                ),
                Center(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(100),
                    dashPattern: const [6, 3],
                    color: Colors.black,
                    strokeWidth: 2,
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height*0.2,
                      child:   Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.sizeOf(context).width*0.40,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Center(
                                    child: IconButton(
                                    onPressed: () {
                                      AlertDialog alertbox= AlertDialog(
                                        title: const Text("Please verify your gmailID"),
                                        actions:
                                        <Widget>[
                                          TextButton(onPressed: ()async{
                                            selectImage(ImageSource.gallery);
                                          }, child: const Text("From the Gallery"),),
                                          TextButton(onPressed: (){
                                            selectImage(ImageSource.camera);
                                          }, child: const Text("From the Camera"))
                                        ],
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alertbox;
                                        },
                                      );
                                      selectImage(ImageSource.gallery);
                                    },
                                    icon: Center(child: Icon(Icons.person, size: 120,)),                                     ),
                                  ),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Text(
                            "Employment ID",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 20),
                          const Icon(
                            Icons.verified_outlined,
                            color: Colors.red,
                            size: 25,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: TextField(
                                  controller: mobileNumber,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your ID',
                                    hintStyle: Theme.of(context).textTheme.labelMedium,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    border: InputBorder.none,
                                  ),
                                ),

                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company Address",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: address,
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Enter Your Company Address',
                                  hintStyle: Theme.of(context).textTheme.labelMedium,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Role",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: city,
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Your Role',
                                  hintStyle: Theme.of(context).textTheme.labelMedium,
                                  contentPadding: const EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "email",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: state,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Enter Your New Email',
                                hintStyle: Theme.of(context).textTheme.labelMedium,
                                contentPadding: const EdgeInsets.all(10.0),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width*0.1,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: ElevatedButton(
                          onPressed: () {
                            editYourBasicDetails();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 40),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          child: const Text(
                            "Save",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
