import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Casilla reutilizable que admite exclusivamente un dígito ASCII.
class CodeBox extends StatelessWidget {
  const CodeBox({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
    super.key,
  });
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  @override
  Widget build(BuildContext context) => Focus(
    onKeyEvent: (_, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.backspace &&
          controller.text.isEmpty) {
        onBackspace();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
    child: TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      textInputAction: index == 3 ? TextInputAction.done : TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      onChanged: onChanged,
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        counterText: '',
        semanticCounterText: '',
        hintText: '0',
        labelText: null,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    ),
  );
}
