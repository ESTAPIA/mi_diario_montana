import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/salida_montana.dart';

class RegistrarSalidaScreen extends StatefulWidget {
  const RegistrarSalidaScreen({super.key});

  @override
  State<RegistrarSalidaScreen> createState() => _RegistrarSalidaScreenState();
}

class _RegistrarSalidaScreenState extends State<RegistrarSalidaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _tipoController = TextEditingController();
  DateTime? _fecha;

  bool _isLoading = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  Future<void> _guardarSalida() async {
    if (!_formKey.currentState!.validate() || _fecha == null) return;
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final salida = SalidaMontana(
      titulo: _tituloController.text.trim(),
      tipo: _tipoController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      fecha: _fecha!,
      usuarioId: user.uid,
    );

    await FirebaseFirestore.instance.collection('salidas').add(salida.toMap());

    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salida registrada exitosamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar nueva salida')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo (ej: Trekking)',
                ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 6,
                validator:
                    (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 6),
              ListTile(
                title: Text(
                  _fecha == null
                      ? 'Selecciona una fecha'
                      : "${_fecha!.day}/${_fecha!.month}/${_fecha!.year}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 5),
                  );
                  if (picked != null) setState(() => _fecha = picked);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _guardarSalida,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Registrar salida'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
