import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Un TextField reutilizable y personalizable para formularios de login y registro.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.show');
      },
    );
  }
}
