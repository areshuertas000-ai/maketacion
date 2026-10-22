import 'package:flutter/material.dart';
import '../models/auth_session.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_input.dart';
import '../widgets/auth_parts.dart';
import '../widgets/auth_scaffold.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _accepted = false;
  bool _termsError = false;
  @override
  void dispose() {
    for (final controller in [_name, _email, _password, _confirmation]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _register() {
    final valid = _form.currentState!.validate();
    setState(() => _termsError = !_accepted);
    if (!valid || !_accepted) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(
          session: AuthSession(
            email: _email.text.trim(),
            fullName: _name.text.trim(),
          ),
        ),
      ),
      (_) => false,
    );
  }

  void _showTerms() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Términos y privacidad'),
      content: const Text(
        'Esta es una maqueta académica. Los datos se usan únicamente '
        'durante la navegación y no se guardan ni se envían a ningún servidor. '
        'Google, Apple y el envío de correos están simulados.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => AuthScaffold(
    decoration: AuthDecoration.register,
    onBack: () => Navigator.pop(context),
    footer: AuthFooter(
      text: '¿Ya tienes cuenta?',
      action: 'Inicia sesión',
      onPressed: () => Navigator.pop(context),
    ),
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeading(
            title: 'Crea tu cuenta',
            subtitle: 'Completa tus datos para empezar',
          ),
          const SizedBox(height: 24),
          AuthInput(
            label: 'Nombre completo',
            hint: 'Juan Pérez',
            controller: _name,
            keyboardType: TextInputType.name,
            validator: (v) => Validators.required(v, 'El nombre'),
            autofillHints: const [AutofillHints.name],
          ),
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
            hint: 'Mínimo 8 caracteres',
            controller: _password,
            isPassword: true,
            validator: Validators.password,
            autofillHints: const [AutofillHints.newPassword],
          ),
          AuthInput(
            label: 'Confirmar contraseña',
            hint: 'Repite tu contraseña',
            controller: _confirmation,
            isPassword: true,
            validator: (v) => Validators.confirm(v, _password.text),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _register(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                height: 48,
                child: Checkbox(
                  value: _accepted,
                  semanticLabel:
                      'Acepto los términos y la política de privacidad',
                  activeColor: AppTheme.purple,
                  onChanged: (value) => setState(() {
                    _accepted = value ?? false;
                    _termsError = false;
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Acepto los ',
                        style: TextStyle(fontSize: 12, color: AppTheme.muted),
                      ),
                      InkWell(
                        onTap: _showTerms,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Términos y condiciones',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.purple,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        ' y la ',
                        style: TextStyle(fontSize: 12, color: AppTheme.muted),
                      ),
                      InkWell(
                        onTap: _showTerms,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Política de privacidad',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.purple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_termsError)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Debes aceptar los términos y la política de privacidad.',
                style: TextStyle(color: Color(0xFFBA1A1A), fontSize: 12),
              ),
            ),
          const SizedBox(height: 12),
          AuthButton(label: 'Crear cuenta', onPressed: _register),
        ],
      ),
    ),
  );
}
