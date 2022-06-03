// ignore_for_file: file_names
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:coba/CapturePage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SignUpPage.dart';
import 'package:coba/AuthProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _passwordVisibility;
  int _counter;
  final rdatabase = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordVisibility = false;
    _activateListener();
  }

  void _activateListener() {
    rdatabase.child('cobi/TLogin').onValue.listen((event) {
      final int _jumlahLogin = event.snapshot.value;
      setState(() {
        _counter = _jumlahLogin;
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dbpath = rdatabase.child('/cobi');

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                  //Input Email
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
                                      _passwordVisibility =
                                          !_passwordVisibility),
                                  child: Icon(
                                      _passwordVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.black54,
                                      size: 22),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //Button Login dan Daftar
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
                              bool res = await AuthProvider().signInWithEmail(
                                  _emailController.text,
                                  _passwordController.text);
                              _passwordVisibility = false;

                              if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                const CircularProgressIndicator();
                                const snackBar = SnackBar(
                                    content: Text(
                                        'Email atau Kata Sandi Tidak Boleh Kosong :('));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              }

                              if (!res) {
                                const snackBar = SnackBar(
                                  content:
                                      Text('Email atau Kata Sandi Salah KK :('),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                try {
                                  _incrementCounter();
                                  await dbpath.set({'TLogin': _counter});
                                  Navigator.push(
                                    context,
                                    CircularClipRoute<void>(
                                        expandFrom: context,
                                        builder: (context) => CapturePage()),
                                  );
                                  print('babi');
                                } catch (e) {
                                  print('anying error $e');
                                }
                              }
                            },
                            child: Text(
                              "Login",
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
                              'Belum punya akun?',
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
                                    builder: (context) =>
                                        const SignUpPageWidget(),
                                  ),
                                );
                              },
                              child: Text(
                                "Daftar",
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
      ),
    );
  }
}
