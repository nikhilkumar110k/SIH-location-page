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
        body: Container(
        height: MediaQuery.sizeOf(context).height*0.5,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Edit Profile Image",
                style:Theme.of(context).textTheme.headlineMedium,
              ),
              Center(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(13),
                  dashPattern: const [6, 3],
                  color: Colors.red,
                  strokeWidth: 2,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.9,
                    height: MediaQuery.sizeOf(context).height*0.2,
                    child:   Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red,width: 2),
                              borderRadius: BorderRadius.circular(6)
                          ),
                          padding: const EdgeInsets.all(5),
                          width: MediaQuery.sizeOf(context).width*0.40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.file_copy,color: Colors.red,),
                              Flexible(child: ElevatedButton(
                                onPressed: () {
                                  selectImage(ImageSource.gallery);
                                },
                                child: const Text('Choose File'),
                              ),)
                            ],
                          ),
                        ),
                        const Text("Or"),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red,width: 2),
                              borderRadius: BorderRadius.circular(6)
                          ),
                          padding: const EdgeInsets.all(5),
                          width: MediaQuery.sizeOf(context).width*0.40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.camera_alt_outlined,color: Colors.red,),
                              Flexible(child: ElevatedButton(
                                onPressed: () {
                                  selectImage(ImageSource.camera);
                                },
                                child: const Text('Open Camera'),
                              ),)                        ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
      
                children: [
                  Row(
                    children: [
                      Text(
                        "Mobile Number",
                        style: Theme.of(context).textTheme.headlineMedium,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: mobileNumber,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'Enter your number',
                                hintStyle: Theme.of(context).textTheme.labelMedium,
                                contentPadding: const EdgeInsets.all(10.0),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            alignment: AlignmentDirectional.center,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                          },
                          child: Text(
                            'Change',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
      
                children: [
                  Text(
                    "Address",
                    style: Theme.of(context).textTheme.headlineMedium,
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
                            controller: address,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Enter Your New Address',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
      
                children: [
                  Text(
                    "City",
                    style: Theme.of(context).textTheme.headlineMedium,
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
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Enter Your New City',
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
      
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
      
                children: [
                  Text(
                    "State",
                    style: Theme.of(context).textTheme.headlineMedium,
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
                            controller: state,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Enter Your New State',
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
      
      
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
      
                children: [
                  Text(
                    "Pincode",
                    style: Theme.of(context).textTheme.headlineMedium,
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
                            controller: pinCode,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Enter Your New PinCode',
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
                  ElevatedButton(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
