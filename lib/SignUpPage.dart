// ignore_for_file: file_names
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coba/AuthProvider.dart';

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
  bool _passwordVisibility;

  var _nama = '',
      _email = '',
      _password = '',
      _imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/facemaskrecognition-8c4ca.appspot.com/o/userImage%2F1461141.png?alt=media&token=62964631-eb3b-4744-b3da-9357c7350058';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _namaController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    final _users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 75),
                //Logo
                Image.asset('assets/images/black.png', width: 70, height: 70),
                SizedBox(height: 25),
                //Sambutan
                Text('Halo, Selamat Datang di',
                    style: GoogleFonts.lexendDeca(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    )),
                SizedBox(height: 10),
                Text('Kendelanang',
                    style: GoogleFonts.lexendDeca(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )),
                Text('Face & Mask Recognition',
                    style: GoogleFonts.lexendDeca(
                      fontSize: 16,
                      color: Colors.grey[800],
                    )),
                SizedBox(height: 50),

                //input username
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _namaController,
                            obscureText: false,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Masukan Nama Panggilan',
                              hintStyle: GoogleFonts.lexendDeca(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black54,
                              ),
                            ),
                            onChanged: (value) {
                              _nama = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //input email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            obscureText: false,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: GoogleFonts.lexendDeca(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.black54,
                              ),
                            ),
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //input password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisibility,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Kata Sandi',
                              hintStyle: GoogleFonts.lexendDeca(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black54,
                              ),
                              suffixIcon: InkWell(
                                onTap: () => setState(() =>
                                    _passwordVisibility = !_passwordVisibility),
                                child: Icon(
                                    _passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.black54,
                                    size: 22),
                              ),
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 130,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () async {
                            bool res = await AuthProvider().createUserWithemail(
                                _namaController.text,
                                _emailController.text,
                                _passwordController.text);

                            if (_namaController.text.isEmpty ||
                                _emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              const snackBar = SnackBar(
                                content: Text(
                                    'Nama, Email dan Password Tidak Boleh Kosong :('),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              print("Email and password cannot be empty");
                              return;
                            }

                            _users
                                .doc(_auth.currentUser.uid)
                                .set({
                                  'nama': _nama,
                                  'email': _email,
                                  'password': _password,
                                  'imageUrl': _imageUrl,
                                })
                                .then((value) => print('User Added'))
                                .catchError((error) =>
                                    print('Failed to add user $error'));
                            if (!res) {
                              print("signup failed");
                              const snackBar = SnackBar(
                                content: Text('Sign Up Gagal :('),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              Navigator.push(
                                context,
                                CircularClipRoute<void>(
                                    expandFrom: context,
                                    builder: (context) => LoginPage()),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun?',
                            style: GoogleFonts.lexendDeca(
                              color: Colors.black54,
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
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
                              style: GoogleFonts.lexendDeca(
                                color: Colors.deepPurple,
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
    );
  }
}
