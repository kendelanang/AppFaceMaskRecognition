import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'loading.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final imagePicker = ImagePicker();
  File _image;
  String url;
  String _uid;
  String _name;
  String _email;
  String _userImageUrl;

  Future getData() async {
    User user = _auth.currentUser;
    _uid = user.uid;

    final DocumentSnapshot userDoc = user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        _name = userDoc.get('nama');
        _email = user.email;
        _userImageUrl = userDoc.get('imageUrl');
      });
    }
  }

  getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    final _image = File(image.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('userImage')
        .child(_auth.currentUser.displayName + '.jpg');
    final TaskSnapshot snapshot = await ref.putFile(_image);
    //ref.putFile(_image);
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
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var document = snapshot.data;
            String _imageUrl = document["imageUrl"];
            String _nama = document["nama"];
            return Scaffold(
              resizeToAvoidBottomInset: false,
              key: scaffoldKey,
              backgroundColor: Color(0xFF263238),
              body: SafeArea(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0x00EEEEEE),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Selamat datang, ',
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _nama,
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Capture wajah untuk di training',
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 238, 238, 238),
                                ),
                                child: snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? loading()
                                    : Image.network(_imageUrl)),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFFF0A500),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100))),
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
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                            child: loading(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return loading();
          }
        });
  }
}
