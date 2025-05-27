import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/salida_montana.dart';
import 'salida_detail_screen.dart';

class HistorialSalidasScreen extends StatefulWidget {
  const HistorialSalidasScreen({super.key});

  @override
  State<HistorialSalidasScreen> createState() => _HistorialSalidasScreenState();
}

class _HistorialSalidasScreenState extends State<HistorialSalidasScreen> {
  final _searchController = TextEditingController();
  String _filtroTipo = 'Todos';
  String _textoBusqueda = '';

  final List<String> _filtrosTipo = [
    'Todos',
    'Trekking',
    'Senderismo', 
    'Escalada',
    'Ciclismo',
    'Camping',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _obtenerSalidas() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    Query query = FirebaseFirestore.instance
        .collection('salidas')
        .where('usuarioId', isEqualTo: user.uid)
        .orderBy('fecha', descending: true);

    return query.snapshots();
  }

  List<SalidaMontana> _filtrarSalidas(List<SalidaMontana> salidas) {
    return salidas.where((salida) {
      final cumpleTipo = _filtroTipo == 'Todos' || salida.tipo == _filtroTipo;
      final cumpleBusqueda = _textoBusqueda.isEmpty ||
          salida.titulo.toLowerCase().contains(_textoBusqueda.toLowerCase()) ||
          salida.descripcion.toLowerCase().contains(_textoBusqueda.toLowerCase());
      
      return cumpleTipo && cumpleBusqueda;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Salidas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/registrar-salida'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar salidas...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _textoBusqueda = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _filtroTipo,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar por tipo',
                    border: OutlineInputBorder(),
                  ),
                  items: _filtrosTipo.map((String tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _filtroTipo = newValue ?? 'Todos';
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _obtenerSalidas(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error al cargar las salidas'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                final salidas = docs
                    .map((doc) => SalidaMontana.fromFirestore(doc))
                    .cast<SalidaMontana>()
                    .toList();

                final salidasFiltradas = _filtrarSalidas(salidas);

                if (salidasFiltradas.isEmpty) {
                  return const Center(
                    child: Text(
                      'No se encontraron salidas',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: salidasFiltradas.length,
                  itemBuilder: (context, index) {
                    final salida = salidasFiltradas[index];
                    final docId = docs[index].id;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            salida.tipo[0].toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          salida.titulo,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(salida.tipo),
                            Text(
                              "${salida.fecha.day}/${salida.fecha.month}/${salida.fecha.year}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SalidaDetailScreen(
                                salida: salida,
                                docId: docId,
                              ),
                            ),
                          );
                          // No necesitamos hacer nada aquí porque usamos StreamBuilder
                          // que se actualiza automáticamente con cambios de Firestore
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}