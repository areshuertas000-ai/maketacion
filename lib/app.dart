import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Login y Registro',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const LoginScreen(),
  );
}
