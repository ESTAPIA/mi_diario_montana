import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/salida_montana.dart';
import '../services/notification_service.dart';

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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  String? _tipoSeleccionado;
  DateTime? _fecha;

  bool _isLoading = false;

  final List<String> _tiposActividad = [
    'Trekking',
    'Senderismo',
    'Escalada',
    'Ciclismo',
    'Camping',
  ];

  @override
  void initState() {
    super.initState();
    // Precargar datos de la salida
    _tituloController = TextEditingController(text: widget.salida.titulo);
    _descripcionController = TextEditingController(text: widget.salida.descripcion);
    _tipoSeleccionado = widget.salida.tipo;
    _fecha = widget.salida.fecha;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _actualizarSalida() async {
    if (!_formKey.currentState!.validate() || _fecha == null || _tipoSeleccionado == null) {
      NotificationService.showError(context, 'Por favor completa todos los campos requeridos');
      return;
    }
    
    setState(() => _isLoading = true);

    final salidaActualizada = SalidaMontana(
      titulo: _tituloController.text.trim(),
      tipo: _tipoSeleccionado!,
      descripcion: _descripcionController.text.trim(),
      fecha: _fecha!,
      usuarioId: widget.salida.usuarioId,
    );

    try {
      await FirebaseFirestore.instance
          .collection('salidas')
          .doc(widget.docId)
          .update(salidaActualizada.toMap());

      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pop(context, true); // Devolver true para indicar que se actualizó
        NotificationService.showSuccess(context, '¡Salida actualizada exitosamente! ✨');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        NotificationService.showError(context, 'Error al actualizar la salida. Intenta de nuevo.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar salida'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _actualizarSalida,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de actividad',
                  border: OutlineInputBorder(),
                ),
                items: _tiposActividad.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoSeleccionado = newValue;
                  });
                },
                validator: (value) => value == null ? 'Selecciona un tipo de actividad' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 6,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
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
                    initialDate: _fecha ?? now,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 5),
                  );
                  if (picked != null) setState(() => _fecha = picked);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _actualizarSalida,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Actualizar salida'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
