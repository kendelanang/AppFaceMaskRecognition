import 'package:avatar_glow/avatar_glow.dart';
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba/CapturePage.dart';
import 'package:coba/authprovider.dart';
import 'package:coba/loading.dart';
import 'package:coba/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _imagePicker = ImagePicker();
  String _displayTotalLogin = '1';
  String _url;
  String _uid;

  @override
  Widget build(BuildContext context) {
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
            key: scaffoldKey,
            backgroundColor: Colors.blueGrey[900],
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 50, 20, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
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
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    Colors.amber,
                                    Colors.amber[900],
                                  ]),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                      child: Text(
                                        'Status : ',
                                        style: GoogleFonts.lexendDeca(
                                          color: Colors.white,
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 20, 0, 0),
                                      child: Text(
                                        'Login',
                                        style: GoogleFonts.lexendDeca(
                                          color: Colors.white,
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 20, 0, 0),
                                      child: Text(
                                        'Jumlah tamu saat ini : ',
                                        style: GoogleFonts.lexendDeca(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 20, 0, 0),
                                      child: Text(
                                        _displayTotalLogin,
                                        style: GoogleFonts.lexendDeca(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFFF0A500),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CircularClipRoute<void>(
                                  expandFrom: context,
                                  builder: (context) => const CapturePage(),
                                ),
                              );
                            },
                            child: Text(
                              "Capture Image Lagi",
                              style: GoogleFonts.lexendDeca(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFFF0A500),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100))),
                            onPressed: () async {
                              final rep = FirebaseDatabase.instance.ref();
                              final snepsot =
                                  await rep.child('cobi/TLogin').get();
                              if (snepsot.exists) {
                                _displayTotalLogin = snepsot.value;
                                print(snepsot.value);
                              } else {
                                print('No data available.');
                              }
                            },
                            child: Text(
                              "Refresh",
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
      },
    );
  }
}
