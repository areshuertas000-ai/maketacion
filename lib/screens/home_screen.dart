import 'package:flutter/material.dart';
import '../models/auth_session.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_scaffold.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.session, super.key});
  final AuthSession session;
  @override
  Widget build(BuildContext context) => AuthScaffold(
    decoration: AuthDecoration.home,
    centerContent: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppTheme.gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.pink.withValues(alpha: 0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: session.fullName.isEmpty
                  ? const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 52,
                    )
                  : Text(
                      session.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          '¡Bienvenido!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (session.fullName.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(session.fullName, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 14),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE5FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.mail_outline,
                  size: 15,
                  color: AppTheme.purple,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    session.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.purple,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        AuthButton(
          label: 'Cerrar sesión',
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
            (_) => false,
          ),
        ),
      ],
    ),
  );
}
