import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_parts.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/code_box.dart';
import 'new_password_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({required this.email, super.key});
  final String email;
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _nodes = List.generate(4, (_) => FocusNode());
  Timer? _timer;
  int _remaining = 45;
  bool get _complete =>
      _controllers.every((c) => RegExp(r'^\d$').hasMatch(c.text));
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _remaining--);
      if (_remaining == 0) timer.cancel();
    });
  }

  void _resend() {
    if (_remaining > 0) return;
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() => _remaining = 45);
    _startTimer();
    _nodes.first.requestFocus();
    showNotice(context, 'Código reenviado (simulación).');
  }

  void _change(int index, String value) {
    setState(() {});
    if (value.isNotEmpty && index < 3) _nodes[index + 1].requestFocus();
    if (value.isEmpty && index > 0) _nodes[index - 1].requestFocus();
  }

  void _verify() {
    if (!_complete) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewPasswordScreen(email: widget.email),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    decoration: AuthDecoration.verification,
    onBack: () => Navigator.pop(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: GradientIcon(
            icon: Icons.verified_user_outlined,
            gradient: LinearGradient(
              colors: [Color(0xFFFF607D), Color(0xFFFF8B24)],
            ),
          ),
        ),
        const SizedBox(height: 32),
        const AuthHeading(
          title: 'Verifica tu correo',
          subtitle: 'Escribe el código de 4 dígitos que enviamos a',
        ),
        const SizedBox(height: 4),
        Text(
          widget.email,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 28),
        Row(
          children: List.generate(
            4,
            (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
                child: Semantics(
                  label: 'Dígito ${i + 1} del código',
                  child: CodeBox(
                    index: i,
                    controller: _controllers[i],
                    focusNode: _nodes[i],
                    onChanged: (v) => _change(i, v),
                    onBackspace: () {
                      if (i > 0) _nodes[i - 1].requestFocus();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '¿No te llegó?',
              style: TextStyle(fontSize: 12, color: AppTheme.muted),
            ),
            TextButton(
              onPressed: _remaining == 0 ? _resend : null,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.purple,
                disabledForegroundColor: AppTheme.purple,
                textStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 12),
              ),
              child: Text(
                _remaining == 0
                    ? 'Reenviar código'
                    : 'Reenviar código en 00:${_remaining.toString().padLeft(2, '0')}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AuthButton(label: 'Siguiente', onPressed: _complete ? _verify : null),
      ],
    ),
  );
}
