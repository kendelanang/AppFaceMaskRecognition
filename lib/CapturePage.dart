import 'dart:io';
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba/Dashboard.dart';
import 'package:coba/authprovider.dart';
import 'package:coba/main.dart';
import 'package:coba/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coba/Loading.dart';
import 'package:avatar_glow/avatar_glow.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({Key key}) : super(key: key);

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _imagePicker = ImagePicker();

  getImage() async {
    final _compressImage = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    final _image = File(_compressImage.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('userImage')
        .child(_auth.currentUser.displayName + '.jpg');
    final TaskSnapshot snapshot = await ref.putFile(_image);
    final url = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({
      'imageUrl': url,
    });
  }

  @override
  Widget build(BuildContext context) {
    final _path = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .snapshots();

    return StreamBuilder(
      stream: _path,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var document = snapshot.data;
          String _imageUrl = document["imageUrl"];
          String _nama = document["nama"];

          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),

                        //Avatar dan Nama
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AvatarGlow(
                                  glowColor: Colors.deepPurple,
                                  endRadius: 30.0,
                                  child: Material(
                                    // Replace this child with your own
                                    elevation: 8.0,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.deepPurple,
                                      backgroundImage: NetworkImage(
                                        _imageUrl,
                                      ),
                                      radius: 20.0,
                                    ),
                                  )),
                              Text(
                                'Selamat datang, ',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _nama,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lexendDeca(
                                  color: Colors.deepPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Capture wajah untuk di training',
                                style: GoogleFonts.lexendDeca(
                                  color: Colors.grey[800],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Container(
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child:
                                snapshot.connectionState == ConnectionState.none
                                    ? Loading()
                                    : Image.network(
                                        _imageUrl,
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          return child;
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Container(
                                              child: Loading(),
                                            );
                                          }
                                        },
                                      ),
                          ),
                        ),
                        SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              getImage();
                            },
                            child: Text(
                              "Capture",
                              style: GoogleFonts.lexendDeca(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          'Sudah cocok?',
                          style: GoogleFonts.lexendDeca(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CircularClipRoute<void>(
                                expandFrom: context,
                                builder: (context) => const navigation(),
                              ),
                            );
                          },
                          child: Text(
                            "Buka Dashboard",
                            style: GoogleFonts.lexendDeca(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Yakin Mau Logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            AuthProvider().logOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          },
                          child: Text(
                            'YES',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'NO',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.logout),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
