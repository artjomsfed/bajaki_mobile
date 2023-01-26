import 'package:bajaki_mobile/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:bajaki_mobile/pages/application_form.dart';


void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => Home(),
    // '/apply': (context) => Application(),
  },
  // home: Application(),
));




