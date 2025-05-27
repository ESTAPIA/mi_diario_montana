// Widget personalizado para campos de texto reutilizables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_text_field.dart';
import '../services/notification_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validar formato de email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Traducción de errores de Firebase Auth
  String _firebaseErrorToSpanish(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'El correo ya está en uso';
      case 'invalid-email':
        return 'Correo no válido';
      case 'weak-password':
        return 'Contraseña muy débil (mínimo 6 caracteres)';
      default:
        return 'Error inesperado. Intenta de nuevo.';
    }
  }

  void _showMessage(String message) {
    NotificationService.showError(context, message);
  }

  void _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validaciones
    if (email.isEmpty || password.isEmpty) {
      NotificationService.showError(context, 'Por favor completa todos los campos');
      return;
    }
    if (!_isValidEmail(email)) {
      NotificationService.showError(context, 'Ingresa un correo válido');
      return;
    }
    if (password.length < 6) {
      NotificationService.showError(context, 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      NotificationService.showSuccess(context, '¡Cuenta creada exitosamente! 🎉');
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      NotificationService.showError(context, _firebaseErrorToSpanish(e.code));
    } catch (_) {
      if (!mounted) return;
      NotificationService.showError(context, 'Error inesperado. Intenta de nuevo.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crear una cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _emailController,
              labelText: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Contraseña',
              obscureText: true,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text('Registrarse'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
              child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
