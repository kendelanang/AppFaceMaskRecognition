import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba/authprovider.dart';
import 'package:coba/main.dart';
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
  String _url;
  String _uid;

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
                                AvatarGlow(
                                  endRadius: 30.0,
                                  child: Material(
                                    // Replace this child with your own
                                    elevation: 8.0,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      backgroundImage: NetworkImage(
                                        _imageUrl,
                                      ),
                                      radius: 20.0,
                                    ),
                                  ),
                                ),
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
                                      ConnectionState.none
                                  ? Loading()
                                  : Image.network(_imageUrl, frameBuilder:
                                      (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                      return child;
                                    }, loadingBuilder:
                                      (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Container(
                                          child: Loading(),
                                        );
                                      }
                                    }),
                            ),
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
                backgroundColor: const Color(0xFFF0A500),
                child: const Icon(Icons.logout),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
