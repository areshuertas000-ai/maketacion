import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthInput extends StatefulWidget {
  const AuthInput({
    required this.label,
    required this.controller,
    super.key,
    this.hint,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          autofillHints: widget.autofillHints,
          autocorrect:
              !widget.isPassword &&
              widget.keyboardType != TextInputType.emailAddress,
          enableSuggestions: !widget.isPassword,
          textCapitalization: widget.keyboardType == TextInputType.name
              ? TextCapitalization.words
              : TextCapitalization.none,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(fontSize: 14, color: AppTheme.ink),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _obscure
                        ? 'Mostrar ${widget.label.toLowerCase()}'
                        : 'Ocultar ${widget.label.toLowerCase()}',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 19,
                      color: AppTheme.muted,
                    ),
                  )
                : null,
          ),
        ),
      ],
    ),
  );
}
