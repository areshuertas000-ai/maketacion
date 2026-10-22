import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum AuthButtonStyle { primary, secondary }

class AuthButton extends StatelessWidget {
  const AuthButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.style = AuthButtonStyle.primary,
    this.leading,
  });
  final String label;
  final VoidCallback? onPressed;
  final AuthButtonStyle style;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    final primary = style == AuthButtonStyle.primary;
    return Opacity(
      opacity: onPressed == null ? 0.45 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: primary ? AppTheme.gradient : null,
          color: primary ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: primary ? null : Border.all(color: const Color(0xFFE4E6EE)),
          boxShadow: primary && onPressed != null
              ? [
                  BoxShadow(
                    color: AppTheme.pink.withValues(alpha: 0.23),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ]
              : null,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: primary ? Colors.white : AppTheme.ink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 10)],
                Flexible(child: Text(label, textAlign: TextAlign.center)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
