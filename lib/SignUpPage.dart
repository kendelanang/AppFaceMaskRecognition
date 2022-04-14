// ignore_for_file: file_names
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coba/authprovider.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUpPageWidget extends StatefulWidget {
  const SignUpPageWidget({Key key}) : super(key: key);

  @override
  _SignUpPageWidgetState createState() => _SignUpPageWidgetState();
}

class _SignUpPageWidgetState extends State<SignUpPageWidget> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController;
  TextEditingController _namaController;
  TextEditingController _passwordController;
  bool passwordVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var nama = '',
      email = '',
      password = '',
      imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/facemaskrecognition-8c4ca.appspot.com/o/userImage%2F1461141.png?alt=media&token=62964631-eb3b-4744-b3da-9357c7350058';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _namaController = TextEditingController();
    _passwordController = TextEditingController();
    passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: const Color(0xFF263238),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
            ),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 90),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/kndlbunder.png',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kendelanang',
                                style: GoogleFonts.lexendDeca(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Face & Mask Recognition',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.lexendDeca(
                                  color: const Color(0xFF90A4AE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Daftar',
                        style: GoogleFonts.lexendDeca(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _namaController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Masukan Nama Panggilan',
                              hintStyle: GoogleFonts.lexendDeca(
                                color: const Color(0xFF95A1AC),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      16, 24, 0, 24),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFF263238),
                              ),
                            ),
                            onChanged: (value) {
                              nama = value;
                            },
                            style: GoogleFonts.lexendDeca(
                              color: const Color(0xFF2B343A),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Masukan Email',
                              hintStyle: GoogleFonts.lexendDeca(
                                color: const Color(0xFF95A1AC),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      16, 24, 0, 24),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color(0xFF263238),
                              ),
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                            style: GoogleFonts.lexendDeca(
                              color: const Color(0xFF2B343A),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !passwordVisibility,
                            decoration: InputDecoration(
                              hintText: 'Masukan Password',
                              hintStyle: GoogleFonts.lexendDeca(
                                color: const Color(0xFF95A1AC),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      16, 24, 0, 24),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF263238),
                                size: 20,
                              ),
                              suffixIcon: InkWell(
                                onTap: () => setState(
                                  () =>
                                      passwordVisibility = !passwordVisibility,
                                ),
                                child: Icon(
                                  passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF2B343A),
                                  size: 22,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              password = value;
                            },
                            style: GoogleFonts.lexendDeca(
                              color: const Color(0xFF2B343A),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 130,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFFF0A500),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100))),
                            onPressed: () async {
                              if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Tolong isi Semua Form !! ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 13.0);
                                print("Email and password cannot be empty");
                                return;
                              }
                              bool res = await AuthProvider()
                                  .createUserWithemail(
                                      _namaController.text,
                                      _emailController.text,
                                      _passwordController.text);

                              users
                                  .doc(_auth.currentUser.uid)
                                  .set({
                                    'nama': nama,
                                    'email': email,
                                    'password': password,
                                    'imageUrl': imageUrl
                                  })
                                  .then((value) => print('User Added'))
                                  .catchError((error) =>
                                      print('Failed to add user $error'));
                              if (!res) {
                                print("signup failed");
                                Fluttertoast.showToast(
                                    msg: "Sign Up Failed! :(",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 13.0);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePageWidget()),
                                );
                              }
                            },
                            child: Text(
                              "Daftar",
                              style: GoogleFonts.lexendDeca(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun?',
                              style: GoogleFonts.lexendDeca(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  CircularClipRoute<void>(
                                    expandFrom: context,
                                    builder: (context) =>
                                        const HomePageWidget(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: GoogleFonts.lexendDeca(
                                  color: const Color(0xFFF0A500),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
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
