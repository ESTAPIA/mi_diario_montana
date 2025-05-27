import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/salida_montana.dart';
import 'editar_salida_screen.dart';
import 'home_screen.dart';
import '../services/notification_service.dart';

class SalidaDetailScreen extends StatefulWidget {
  final SalidaMontana salida;
  final String docId;

  const SalidaDetailScreen({
    super.key,
    required this.salida,
    required this.docId,
  });

  @override
  State<SalidaDetailScreen> createState() => _SalidaDetailScreenState();
}

class _SalidaDetailScreenState extends State<SalidaDetailScreen> {
  late SalidaMontana _salida;

  @override
  void initState() {
    super.initState();
    _salida = widget.salida;
  }

  void _recargarDatos() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('salidas')
          .doc(widget.docId)
          .get();
      
      if (doc.exists && mounted) {
        setState(() {
          _salida = SalidaMontana.fromFirestore(doc);
        });
      }
    } catch (e) {
      // Error silencioso, mantener datos actuales
    }
  }

  Future<void> _confirmarEliminar(BuildContext context) async {
    final confirmado = await NotificationService.showConfirmDialog(
      context,
      title: 'Eliminar salida',
      message: '¿Estás seguro de que deseas eliminar "${_salida.titulo}"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      confirmColor: Colors.red,
      icon: Icons.delete_forever,
    );

    if (confirmado) {
      try {
        NotificationService.showLoadingDialog(context, 'Eliminando salida...');
        
        await FirebaseFirestore.instance
            .collection('salidas')
            .doc(widget.docId)
            .delete();

        if (context.mounted) {
          Navigator.pop(context); // Cerrar loading dialog
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
          NotificationService.showSuccess(context, '¡Salida eliminada exitosamente! 🗑️');
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); // Cerrar loading dialog
          NotificationService.showError(context, 'Error al eliminar la salida. Intenta de nuevo.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_salida.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar salida',
            onPressed: () async {
              final resultado = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarSalidaScreen(salida: _salida, docId: widget.docId),
                ),
              );
              
              // Si se editó la salida, recargar los datos
              if (resultado == true) {
                _recargarDatos();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Eliminar salida',
            onPressed: () => _confirmarEliminar(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              _salida.titulo,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.category, color: Colors.green),
                const SizedBox(width: 8),
                Text(_salida.tipo, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  "${_salida.fecha.day}/${_salida.fecha.month}/${_salida.fecha.year}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Descripción",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(_salida.descripcion, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
