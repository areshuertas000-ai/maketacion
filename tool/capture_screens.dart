// Genera las capturas desde los widgets reales de Flutter.
// Ejecutar: flutter test tool/capture_screens.dart --update-goldens
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_registro/models/auth_session.dart';
import 'package:login_registro/screens/home_screen.dart';
import 'package:login_registro/screens/login_screen.dart';
import 'package:login_registro/screens/new_password_screen.dart';
import 'package:login_registro/screens/recovery_screen.dart';
import 'package:login_registro/screens/register_screen.dart';
import 'package:login_registro/screens/verification_screen.dart';
import 'package:login_registro/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final configFile = File('.dart_tool/package_config.json').absolute;
    final config =
        jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
    final packages = config['packages'] as List<dynamic>;
    final flutter = packages.cast<Map<String, dynamic>>().firstWhere(
      (p) => p['name'] == 'flutter',
    );
    final sdk = Directory.fromUri(
      configFile.uri.resolve(flutter['rootUri'] as String),
    ).parent.parent;
    Future<ByteData> font(String name) async => ByteData.sublistView(
      await File(
        '${sdk.path}/bin/cache/artifacts/material_fonts/$name',
      ).readAsBytes(),
    );
    await (FontLoader('Roboto')
          ..addFont(font('roboto-regular.ttf'))
          ..addFont(font('roboto-medium.ttf'))
          ..addFont(font('roboto-bold.ttf')))
        .load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(font('materialicons-regular.otf'))).load();
  });
  final screens = <String, Widget>{
    '01-login': const LoginScreen(),
    '02-registro': const RegisterScreen(),
    '03-recuperar': const RecoveryScreen(),
    '04-verificacion': const VerificationScreen(
      email: 'ana@universidad.edu.co',
    ),
    '05-nueva-contrasena': const NewPasswordScreen(
      email: 'ana@universidad.edu.co',
    ),
    '06-home': const HomeScreen(
      session: AuthSession(
        email: 'ana@universidad.edu.co',
        fullName: 'Ana Pérez',
      ),
    ),
  };
  for (final entry in screens.entries) {
    testWidgets('Captura ${entry.key}', (tester) async {
      final previousShadows = debugDisableShadows;
      debugDisableShadows = false;
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        RepaintBoundary(
          key: const Key('capture'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: entry.value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const Key('capture')),
        matchesGoldenFile('../docs/pantallas/${entry.key}.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      debugDisableShadows = previousShadows;
    });
  }
}
