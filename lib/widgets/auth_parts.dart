import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    required this.icon,
    super.key,
    this.size = 64,
    this.gradient = AppTheme.gradient,
    this.round = false,
  });
  final IconData icon;
  final double size;
  final Gradient gradient;
  final bool round;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(round ? size / 2 : 17),
      boxShadow: [
        BoxShadow(
          color: AppTheme.purple.withValues(alpha: 0.2),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Icon(icon, color: Colors.white, size: size * 0.48),
  );
}

class AuthHeading extends StatelessWidget {
  const AuthHeading({
    required this.title,
    required this.subtitle,
    super.key,
    this.centered = false,
  });
  final String title;
  final String subtitle;
  final bool centered;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start,
    children: [
      Text(
        title,
        textAlign: centered ? TextAlign.center : TextAlign.start,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 9),
      Text(
        subtitle,
        textAlign: centered ? TextAlign.center : TextAlign.start,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

class AuthFooter extends StatelessWidget {
  const AuthFooter({
    required this.text,
    required this.action,
    required this.onPressed,
    super.key,
  });
  final String text;
  final String action;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(text, style: Theme.of(context).textTheme.bodySmall),
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          foregroundColor: AppTheme.purple,
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(action),
      ),
    ],
  );
}

class Requirement extends StatelessWidget {
  const Requirement({required this.label, required this.met, super.key});
  final String label;
  final bool met;
  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: ${met ? "cumplido" : "pendiente"}',
    excludeSemantics: true,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: met ? AppTheme.green : AppTheme.muted,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: met ? AppTheme.green : AppTheme.muted,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
