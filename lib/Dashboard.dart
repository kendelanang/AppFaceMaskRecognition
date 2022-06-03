import 'package:avatar_glow/avatar_glow.dart';
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba/CapturePage.dart';
import 'package:coba/LoginPage.dart';
import 'package:coba/authprovider.dart';
import 'package:coba/loading.dart';
import 'package:coba/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _rdatabase = FirebaseDatabase.instance.ref();
  int _displayTotalLogin;

  @override
  void initState() {
    super.initState();
    _activateListener();
  }

  void _activateListener() {
    _rdatabase.child('cobi/TLogin').onValue.listen((event) {
      final int _jumlahLogin = event.snapshot.value;
      setState(() {
        _displayTotalLogin = _jumlahLogin;
      });
    });
  }

  void _decrementCounter() {
    setState(() {
      _displayTotalLogin--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _path = _rdatabase.child('/cobi');
    final _dbpath = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .snapshots();

    return StreamBuilder(
      stream: _dbpath,
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
                        const SizedBox(height: 20),

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
                                  shape: const CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[100],
                                    backgroundImage: NetworkImage(
                                      _imageUrl,
                                    ),
                                    radius: 22.0,
                                  ),
                                ),
                              ),
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
                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    Colors.deepPurple,
                                    Colors.deepPurpleAccent,
                                  ]),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 20, 0, 0),
                                      child: Text(
                                        'Status : Login',
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 20, 0, 0),
                                      child: Text(
                                        "$_displayTotalLogin",
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
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Capture Image Lagi? ',
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
                                    builder: (context) => const CapturePage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Buka Kamera",
                                style: GoogleFonts.lexendDeca(
                                  color: Colors.deepPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
                      title: const Text('Logout'),
                      content: const Text('Yakin Mau Logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            try {
                              _decrementCounter();
                              await _path.set({'TLogin': _displayTotalLogin});
                              print('babi');
                            } catch (e) {
                              print('anying error $e');
                            }
                            AuthProvider().logOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyApp()));
                          },
                          child: const Text(
                            'YES',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
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
          return const Loading();
        }
      },
    );
  }
}
