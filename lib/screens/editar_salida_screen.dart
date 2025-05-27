import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/salida_montana.dart';
import 'home_screen.dart';

class EditarSalidaScreen extends StatefulWidget {
  final SalidaMontana salida;
  final String docId;

  const EditarSalidaScreen({
    super.key,
    required this.salida,
    required this.docId,
  });

  @override
  State<EditarSalidaScreen> createState() => _EditarSalidaScreenState();
}

class _EditarSalidaScreenState extends State<EditarSalidaScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _tipoController;
  late TextEditingController _descripcionController;
  late DateTime _fecha;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.salida.titulo);
    _tipoController = TextEditingController(text: widget.salida.tipo);
    _descripcionController = TextEditingController(
      text: widget.salida.descripcion,
    );
    _fecha = widget.salida.fecha;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _tipoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (_tituloController.text.trim().isEmpty ||
        _tipoController.text.trim().isEmpty ||
        _descripcionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }
    setState(() => _isLoading = true);

    await FirebaseFirestore.instance
        .collection('salidas')
        .doc(widget.docId)
        .update({
          'titulo': _tituloController.text.trim(),
          'tipo': _tipoController.text.trim(),
          'descripcion': _descripcionController.text.trim(),
          'fecha': _fecha.toIso8601String(),
        });

    setState(() => _isLoading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salida actualizada exitosamente')),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar salida')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tipoController,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                "Fecha: ${_fecha.day}/${_fecha.month}/${_fecha.year}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _fecha,
                  firstDate: DateTime(DateTime.now().year - 5),
                  lastDate: DateTime(DateTime.now().year + 5),
                );
                if (picked != null) setState(() => _fecha = picked);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _guardarCambios,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
