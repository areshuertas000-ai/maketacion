import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_input.dart';
import '../widgets/auth_parts.dart';
import '../widgets/auth_scaffold.dart';
import 'login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({required this.email, super.key});
  final String email;
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool get _valid =>
      Validators.isStrong(_password.text) &&
      _confirmation.text == _password.text;
  @override
  void dispose() {
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate() || !_valid) return;
    FocusScope.of(context).unfocus();
    // La contraseña no se persiste: el taller solicita únicamente la maqueta.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => LoginScreen(
          initialEmail: widget.email,
          successMessage: '¡Contraseña restablecida! Ya puedes iniciar sesión.',
        ),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    decoration: AuthDecoration.reset,
    onBack: () => Navigator.pop(context),
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 14, color: AppTheme.green),
                  SizedBox(width: 4),
                  Text(
                    'Código verificado',
                    style: TextStyle(color: AppTheme.green, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Align(
            alignment: Alignment.centerLeft,
            child: GradientIcon(icon: Icons.lock_outline_rounded),
          ),
          const SizedBox(height: 28),
          const AuthHeading(
            title: 'Crea una nueva\ncontraseña',
            subtitle:
                'Tu nueva contraseña debe ser diferente a las que usaste antes.',
          ),
          const SizedBox(height: 26),
          AuthInput(
            label: 'Nueva contraseña',
            hint: '••••••••',
            controller: _password,
            isPassword: true,
            validator: Validators.password,
            onChanged: (_) => setState(() {}),
            autofillHints: const [AutofillHints.newPassword],
          ),
          AuthInput(
            label: 'Confirmar contraseña',
            hint: '••••••••',
            controller: _confirmation,
            isPassword: true,
            validator: (v) => Validators.confirm(v, _password.text),
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _save(),
          ),
          Requirement(
            label: 'Mínimo 8 caracteres',
            met: Validators.hasLength(_password.text),
          ),
          Requirement(
            label: 'Al menos una mayúscula',
            met: Validators.hasUppercase(_password.text),
          ),
          Requirement(
            label: 'Al menos un número',
            met: Validators.hasNumber(_password.text),
          ),
          const SizedBox(height: 20),
          AuthButton(
            label: 'Restablecer contraseña',
            onPressed: _valid ? _save : null,
          ),
        ],
      ),
    ),
  );
}
