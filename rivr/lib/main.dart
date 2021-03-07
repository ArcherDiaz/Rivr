import 'package:firebase_core/firebase_core.dart';
import 'package:rivr/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  Firebase.initializeApp();
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

//TODO: rivr/home
//TODO: rivr/live/join/${roomCode}
