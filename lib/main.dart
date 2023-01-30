import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bajaki_mobile/pages/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future main() async {
  if (kReleaseMode) {
    await dotenv.load(fileName: '.env');
  } else {
    await dotenv.load(fileName: '.env.dev');
  }

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
    },
  ));
}




