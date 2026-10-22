import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_registro/app.dart';
import 'package:login_registro/models/auth_session.dart';
import 'package:login_registro/screens/home_screen.dart';
import 'package:login_registro/screens/login_screen.dart';
import 'package:login_registro/screens/new_password_screen.dart';
import 'package:login_registro/screens/recovery_screen.dart';
import 'package:login_registro/screens/register_screen.dart';
import 'package:login_registro/screens/verification_screen.dart';
import 'package:login_registro/theme/app_theme.dart';
import 'package:login_registro/widgets/auth_button.dart';
import 'package:login_registro/widgets/auth_input.dart';
import 'package:login_registro/widgets/auth_parts.dart';
import 'package:login_registro/widgets/code_box.dart';

Finder input(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AuthInput && w.label == label),
  matching: find.byType(TextFormField),
);

Future<void> tap(WidgetTester tester, String label) async {
  await tester.pump();
  final target = find.text(label).last;
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> launch(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(const AuthApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Login valida campos y correo; Google y Apple informan su estado',
    (tester) async {
      await launch(tester);
      await tap(tester, 'Iniciar sesión');
      expect(find.text('Ingresa tu correo electrónico.'), findsOneWidget);
      expect(
        find.text('La contraseña es un campo obligatorio.'),
        findsOneWidget,
      );
      expect(find.byType(HomeScreen), findsNothing);
      await tester.enterText(input('Correo electrónico'), 'correo-invalido');
      await tester.enterText(input('Contraseña'), '1234');
      await tap(tester, 'Iniciar sesión');
      expect(
        find.text('Ingresa un correo válido: usuario@dominio.com.'),
        findsOneWidget,
      );
      await tap(tester, 'Google');
      expect(find.text('Funcionalidad no disponible'), findsOneWidget);
      await tap(tester, 'Apple');
      expect(find.text('Funcionalidad no disponible'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Login comparte el correo, permite ver contraseña y cierra la sesión',
    (tester) async {
      await launch(tester);
      await tester.enterText(
        input('Correo electrónico'),
        ' estudiante@universidad.edu.co ',
      );
      await tester.enterText(input('Contraseña'), 'Prueba123');
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: input('Contraseña'),
                matching: find.byType(TextField),
              ),
            )
            .obscureText,
        isTrue,
      );
      await tester.tap(find.byTooltip('Mostrar contraseña'));
      await tester.pump();
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: input('Contraseña'),
                matching: find.byType(TextField),
              ),
            )
            .obscureText,
        isFalse,
      );
      await tester.tap(find.byTooltip('Ocultar contraseña'));
      await tap(tester, 'Iniciar sesión');
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('estudiante@universidad.edu.co'), findsOneWidget);
      await tap(tester, 'Cerrar sesión');
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(
        tester
            .widget<TextFormField>(input('Correo electrónico'))
            .controller!
            .text,
        isEmpty,
      );
    },
  );

  testWidgets(
    'Registro rechaza confirmación y términos; después comparte nombre y correo',
    (tester) async {
      await launch(tester);
      await tap(tester, 'Regístrate');
      await tester.enterText(input('Nombre completo'), 'Ana Pérez');
      await tester.enterText(
        input('Correo electrónico'),
        'ana@universidad.edu.co',
      );
      await tester.enterText(input('Contraseña'), 'Prueba123');
      await tester.enterText(input('Confirmar contraseña'), 'Otra1234');
      await tap(tester, 'Crear cuenta');
      expect(find.text('Las contraseñas no coinciden.'), findsOneWidget);
      expect(
        find.text('Debes aceptar los términos y la política de privacidad.'),
        findsOneWidget,
      );
      await tester.enterText(input('Confirmar contraseña'), 'Prueba123');
      await tap(tester, 'Crear cuenta');
      expect(find.byType(HomeScreen), findsNothing);
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox));
      await tap(tester, 'Crear cuenta');
      expect(find.text('Ana Pérez'), findsOneWidget);
      expect(find.text('ana@universidad.edu.co'), findsOneWidget);
      expect(find.text('AP'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Recuperación completa: código numérico, foco, contador y nueva contraseña',
    (tester) async {
      await launch(tester);
      await tap(tester, '¿Olvidaste tu contraseña?');
      await tap(tester, 'Enviar código');
      expect(find.byType(VerificationScreen), findsNothing);
      await tester.enterText(input('Correo electrónico'), 'ana@correo.com');
      await tap(tester, 'Enviar código');
      expect(find.text('ana@correo.com'), findsOneWidget);
      expect(find.textContaining('Reenviar código en 00:'), findsOneWidget);
      final boxes = find.byType(CodeBox);
      final fields = find.byType(TextField);
      expect(boxes, findsNWidgets(4));
      await tester.enterText(fields.at(0), 'a');
      expect(tester.widget<CodeBox>(boxes.at(0)).controller.text, isEmpty);
      await tester.enterText(fields.at(0), '4');
      await tester.pump();
      expect(tester.widget<CodeBox>(boxes.at(1)).focusNode.hasFocus, isTrue);
      await tester.enterText(fields.at(1), '8');
      await tester.enterText(fields.at(1), '');
      await tester.pump();
      expect(tester.widget<CodeBox>(boxes.at(0)).focusNode.hasFocus, isTrue);
      await tester.tap(fields.at(2));
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();
      expect(tester.widget<CodeBox>(boxes.at(1)).focusNode.hasFocus, isTrue);
      await tester.pump(const Duration(seconds: 46));
      await tester.pump();
      expect(find.text('Reenviar código'), findsOneWidget);
      await tap(tester, 'Reenviar código');
      expect(find.text('Reenviar código en 00:45'), findsOneWidget);
      expect(tester.widget<CodeBox>(boxes.at(0)).controller.text, isEmpty);
      for (var i = 0; i < 4; i++) {
        await tester.enterText(fields.at(i), '${i + 1}');
      }
      await tap(tester, 'Siguiente');
      expect(find.byType(NewPasswordScreen), findsOneWidget);
      expect(find.text('Código verificado'), findsOneWidget);
      expect(
        tester
            .widgetList<Requirement>(find.byType(Requirement))
            .where((w) => w.met),
        isEmpty,
      );
      await tester.enterText(input('Nueva contraseña'), 'Nueva123');
      await tester.pump();
      expect(
        tester
            .widgetList<Requirement>(find.byType(Requirement))
            .where((w) => w.met)
            .length,
        3,
      );
      await tester.enterText(input('Confirmar contraseña'), 'Distinta123');
      await tester.pump();
      final save = find.byWidgetPredicate(
        (w) => w is AuthButton && w.label == 'Restablecer contraseña',
      );
      expect(tester.widget<AuthButton>(save).onPressed, isNull);
      await tester.enterText(input('Confirmar contraseña'), 'Nueva123');
      await tester.pump();
      expect(tester.widget<AuthButton>(save).onPressed, isNotNull);
      await tap(tester, 'Restablecer contraseña');
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(
        find.text('¡Contraseña restablecida! Ya puedes iniciar sesión.'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<TextFormField>(input('Correo electrónico'))
            .controller!
            .text,
        'ana@correo.com',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Atrás y los enlaces regresan a la pantalla correcta', (
    tester,
  ) async {
    await launch(tester);
    await tap(tester, 'Regístrate');
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tap(tester, 'Regístrate');
    await tap(tester, 'Inicia sesión');
    await tap(tester, '¿Olvidaste tu contraseña?');
    await tester.enterText(input('Correo electrónico'), 'persona@correo.com');
    await tap(tester, 'Enviar código');
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.byType(RecoveryScreen), findsOneWidget);
    await tap(tester, 'Inicia sesión');
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets(
    'Respeta las barras nativas de Android y permite abrir el teclado',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      for (final keyboardHeight in [0.0, 300.0]) {
        for (final page in [const LoginScreen(), const RegisterScreen()]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.light,
              home: MediaQuery(
                data: MediaQueryData(
                  size: const Size(390, 844),
                  padding: const EdgeInsets.only(top: 48, bottom: 24),
                  viewPadding: const EdgeInsets.only(top: 48, bottom: 24),
                  viewInsets: EdgeInsets.only(bottom: keyboardHeight),
                ),
                child: page,
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('9:41'), findsNothing);
          expect(tester.takeException(), isNull);
        }
      }
    },
  );

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(430, 932),
  ]) {
    testWidgets(
      'Las seis pantallas no desbordan a ${size.width} × ${size.height}',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final pages = <Widget>[
          const LoginScreen(),
          const RegisterScreen(),
          const RecoveryScreen(),
          const VerificationScreen(email: 'persona@correo.com'),
          const NewPasswordScreen(email: 'persona@correo.com'),
          const HomeScreen(
            session: AuthSession(
              email: 'persona@correo.com',
              fullName: 'Ana Pérez',
            ),
          ),
        ];
        for (final page in pages) {
          await tester.pumpWidget(
            MaterialApp(theme: AppTheme.light, home: page),
          );
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${page.runtimeType} a $size',
          );
        }
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
