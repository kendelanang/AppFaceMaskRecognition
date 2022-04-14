// ignore_for_file: file_names
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:coba/selamatdatang.dart';
import 'package:coba/test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SignUpPage.dart';
import 'package:coba/authprovider.dart';

import 'package:coba/loading.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool passwordVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: const Color(0xFF263238),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 180, 0, 90),
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
                    'Login',
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
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              16, 24, 0, 24),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color(0xFF263238),
                          ),
                        ),
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
                          hintText: 'Kata Sandi',
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
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              16, 24, 0, 24),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFF263238),
                            size: 20,
                          ),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                              () => passwordVisibility = !passwordVisibility,
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
                            CircularProgressIndicator();
                            Fluttertoast.showToast(
                                msg: "Tolong isi kedua form !! ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 13.0);
                            print("Email and password Tidak boleh kosong");
                            return;
                          }

                          bool res = await AuthProvider().signInWithEmail(
                              _emailController.text, _passwordController.text);

                          if (!res) {
                            print("Login failed");
                            Fluttertoast.showToast(
                                msg: "Email or password salah kk :(",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 13.0);
                          } else {
                            Navigator.push(
                              context,
                              CircularClipRoute<void>(
                                  expandFrom: context,
                                  builder: (context) => TestPage()),
                            );
                          }
                          Fluttertoast.showToast(
                              msg: "Anda menekan button login",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: const Color(0xFFF0A500),
                              textColor: Colors.white,
                              fontSize: 16.0);
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
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: GoogleFonts.lexendDeca(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Fluttertoast.showToast(
                                msg: "Anda Menekan Button Daftar",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: const Color(0xFFF0A500),
                                textColor: Colors.white,
                                fontSize: 16.0);
                            await Navigator.push(
                              context,
                              CircularClipRoute<void>(
                                expandFrom: context,
                                builder: (context) => const SignUpPageWidget(),
                              ),
                            );
                          },
                          child: Text(
                            "Daftar",
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
    );
  }
}
