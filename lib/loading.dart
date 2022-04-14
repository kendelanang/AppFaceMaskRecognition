import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(0, 215, 204, 200),
      child: Center(
        child: SpinKitFoldingCube(
          color: Color(0xFFF0A500),
          size: 50.0,
        ),
      ),
    );
  }
}
