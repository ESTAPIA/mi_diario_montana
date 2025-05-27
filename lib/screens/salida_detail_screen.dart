import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/salida_montana.dart';
import 'editar_salida_screen.dart';
import 'home_screen.dart';

class SalidaDetailScreen extends StatelessWidget {
  final SalidaMontana salida;
  final String docId;

  const SalidaDetailScreen({
    super.key,
    required this.salida,
    required this.docId,
  });

  Future<void> _confirmarEliminar(BuildContext context) async {
    final bool? confirmado = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar salida'),
            content: const Text(
              '¿Estás seguro de que deseas eliminar esta salida? Esta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Eliminar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    );

    if (confirmado == true) {
      // Elimina el documento de Firestore
      await FirebaseFirestore.instance
          .collection('salidas')
          .doc(docId)
          .delete();

      // Vuelve al Home y muestra SnackBar
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salida eliminada exitosamente ✅')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(salida.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar salida',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => EditarSalidaScreen(salida: salida, docId: docId),
                ),
              );
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
              salida.titulo,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.category, color: Colors.green),
                const SizedBox(width: 8),
                Text(salida.tipo, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  "${salida.fecha.day}/${salida.fecha.month}/${salida.fecha.year}",
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
            Text(salida.descripcion, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
