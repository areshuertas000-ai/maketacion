import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_input.dart';
import '../widgets/auth_parts.dart';
import '../widgets/auth_scaffold.dart';
import 'verification_screen.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key, this.initialEmail = ''});
  final String initialEmail;
  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _email;
  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _send() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VerificationScreen(email: _email.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    decoration: AuthDecoration.recovery,
    onBack: () => Navigator.pop(context),
    footer: AuthFooter(
      text: '¿La recordaste?',
      action: 'Inicia sesión',
      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
    ),
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: GradientIcon(
              icon: Icons.mail_outline,
              gradient: LinearGradient(
                colors: [Color(0xFF13B8D1), Color(0xFF3B82F6)],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const AuthHeading(
            title: '¿Olvidaste tu\ncontraseña?',
            subtitle:
                'Ingresa el correo con el que te registraste y te enviaremos un código de 4 dígitos.',
          ),
          const SizedBox(height: 28),
          AuthInput(
            label: 'Correo electrónico',
            hint: 'tu@correo.com',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _send(),
          ),
          const SizedBox(height: 8),
          AuthButton(label: 'Enviar código', onPressed: _send),
        ],
      ),
    ),
  );
}
