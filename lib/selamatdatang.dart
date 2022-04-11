import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coba/authprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba/SignUpPage.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BangetWidget extends StatefulWidget {
  const BangetWidget({Key key}) : super(key: key);

  @override
  _BangetWidgetState createState() => _BangetWidgetState();
}

class _BangetWidgetState extends State<BangetWidget> {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;
  File _image;
  String url;
  String _uid;
  String _name;
  String _email;
  String _userImageUrl;
  String cuba =
      'https://firebasestorage.googleapis.com/v0/b/facemaskrecognition-8c4ca.appspot.com/o/userImage%2F1461141.png?alt=media&token=62964631-eb3b-4744-b3da-9357c7350058';
  final imagePicker = ImagePicker();

  @override
  void initState() {
    this.checkAuthentification();
    getData();
    super.initState();
  }

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

  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    final _image = File(image.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('userImage')
        .child(_auth.currentUser.displayName + '.jpg');
    ref.putFile(_image);
    url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({
      'imageUrl': url,
    });
  }

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  signOut() async {
    _auth.signOut();
  }

  Widget build(BuildContext context) {
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
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
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
                          _name,
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
                    padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
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
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(0, 238, 238, 238),
                        ),
                        child: Image.network(_userImageUrl)),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFF0A500),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100))),
                      onPressed: () {
                        getImage();
                        if (_image == null) {
                          Fluttertoast.showToast(
                              msg: ("Hehe"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: const Color(0xFFF0A500),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        Fluttertoast.showToast(
                            msg: ("Anda menekan button capture"),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: const Color(0xFFF0A500),
                            textColor: Colors.white,
                            fontSize: 16.0);
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
                    padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: users,
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot,
                              ) {
                                if (snapshot.hasError) {
                                  return Text(
                                    "Ada yang salah",
                                    style: GoogleFonts.lexendDeca(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    'Loading',
                                    style: GoogleFonts.lexendDeca(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  );
                                }

                                final data = snapshot.requireData;

                                return ListView.builder(
                                  itemCount: data.size,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      '',
                                      // 'emailku ${data.docs[index]['email']} dan namaku ${data.docs[index]['nama']}',
                                      style: GoogleFonts.lexendDeca(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    );
                                  },
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
