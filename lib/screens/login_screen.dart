import 'package:flutter/material.dart';
import '../models/auth_session.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_input.dart';
import '../widgets/auth_parts.dart';
import '../widgets/auth_scaffold.dart';
import 'home_screen.dart';
import 'recovery_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.initialEmail = '', this.successMessage});
  final String initialEmail;
  final String? successMessage;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _email;
  final _password = TextEditingController();
  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final session = AuthSession(email: _email.text.trim());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => HomeScreen(session: session)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    decoration: AuthDecoration.login,
    footer: AuthFooter(
      text: '¿No tienes cuenta?',
      action: 'Regístrate',
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const RegisterScreen())),
    ),
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: GradientIcon(icon: Icons.lock_outline_rounded, size: 72),
          ),
          const SizedBox(height: 24),
          const AuthHeading(
            title: 'Bienvenido de nuevo',
            subtitle: 'Inicia sesión para continuar',
            centered: true,
          ),
          const SizedBox(height: 28),
          if (widget.successMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  widget.successMessage!,
                  style: const TextStyle(color: AppTheme.green, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          AuthInput(
            label: 'Correo electrónico',
            hint: 'tu@correo.com',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            autofillHints: const [AutofillHints.email],
          ),
          AuthInput(
            label: 'Contraseña',
            hint: '••••••••',
            controller: _password,
            isPassword: true,
            validator: (v) => Validators.required(v, 'La contraseña'),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _login(),
            autofillHints: const [AutofillHints.password],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      RecoveryScreen(initialEmail: _email.text.trim()),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.purple,
                textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
          const SizedBox(height: 8),
          AuthButton(label: 'Iniciar sesión', onPressed: _login),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Row(
              children: [
                Expanded(child: Divider(color: Color(0xFFE4E6EE))),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'o continúa con',
                    style: TextStyle(fontSize: 12, color: AppTheme.muted),
                  ),
                ),
                Expanded(child: Divider(color: Color(0xFFE4E6EE))),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AuthButton(
                  label: 'Google',
                  style: AuthButtonStyle.secondary,
                  leading: const Text(
                    'G',
                    style: TextStyle(
                      color: Color(0xFF4285F4),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onPressed: () =>
                      showNotice(context, 'Funcionalidad no disponible'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AuthButton(
                  label: 'Apple',
                  style: AuthButtonStyle.secondary,
                  leading: const Icon(Icons.apple, size: 23),
                  onPressed: () =>
                      showNotice(context, 'Funcionalidad no disponible'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
