import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/salida_montana.dart';
import 'salida_detail_screen.dart';
import 'registrar_salida_screen.dart';
import 'login_screen.dart';
import '../services/notification_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  IconData _getIconForTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'trekking':
      case 'senderismo':
        return FontAwesomeIcons.personHiking;
      case 'escalada':
        return FontAwesomeIcons.mountain;
      case 'ciclismo':
        return FontAwesomeIcons.bicycle;
      case 'camping':
        return FontAwesomeIcons.campground;
      default:
        return Icons.terrain;
    }
  }

  Color _getColorForTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'trekking':
      case 'senderismo':
        return Colors.green;
      case 'escalada':
        return Colors.orange;
      case 'ciclismo':
        return Colors.blue;
      case 'camping':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Validación: Si no hay usuario, redirige a login y muestra SnackBar
    if (user == null) {
      // Usar addPostFrameCallback para evitar errores de navegación en build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión para continuar')),
        );
      });
      // Retornar un widget vacío mientras navega
      return const SizedBox.shrink();
    }

    final String? userEmail = user.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final confirmado = await NotificationService.showConfirmDialog(
                context,
                title: 'Cerrar sesión',
                message: '¿Estás seguro de que deseas cerrar sesión?',
                confirmText: 'Cerrar sesión',
                cancelText: 'Cancelar',
                icon: Icons.logout,
              );

              if (confirmado) {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                  NotificationService.showInfo(context, 'Sesión cerrada exitosamente 👋');
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo personalizado
            Text(
              'Hola, ${userEmail ?? "usuario"}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Botón para registrar nueva salida
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_location_alt),
                label: const Text('Registrar nueva salida'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegistrarSalidaScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Título de historial
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Historial de salidas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/historial-salidas');
                  },
                  icon: const Icon(Icons.list_alt, size: 20),
                  label: const Text('Ver todo'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Lista base para historial (sin datos aún)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('salidas')
                    .where(
                      'usuarioId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                    )
                    .orderBy('fecha', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No hay salidas registradas.'),
                    );
                  }
                  final salidas = snapshot.data!.docs
                      .map(
                        (doc) => SalidaMontana.fromMap(
                          doc.data() as Map<String, dynamic>,
                        ),
                      )
                      .toList();
                  return ListView.separated(
                    itemCount: salidas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final salida = salidas[index];
                      final docId = snapshot.data!.docs[index].id;
                      final tipoColor = _getColorForTipo(salida.tipo);
                      final tipoIcon = _getIconForTipo(salida.tipo);

                      return Card(
                        elevation: 4,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
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
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: tipoColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    tipoIcon,
                                    color: tipoColor,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        salida.titulo,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: tipoColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              salida.tipo,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: tipoColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${salida.fecha.day}/${salida.fecha.month}/${salida.fecha.year}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
