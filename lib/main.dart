import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tviyvxjwaxdzcibdxzwm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR2aXl2eGp3YXhkemNpYmR4endtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1MTA0MDYsImV4cCI6MjA0NzA4NjQwNn0.v7P5Mi7cctbMg8jZADp_inqewb7-RnYDLRNRnr0S7UI',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Supabase Login',
      home: LoginPage(),
    );
  }
}