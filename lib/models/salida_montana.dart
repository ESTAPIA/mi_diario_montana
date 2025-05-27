class SalidaMontana {
  final String titulo;
  final String tipo;
  final String descripcion;
  final DateTime fecha;
  final String usuarioId; // o puedes usar userEmail

  SalidaMontana({
    required this.titulo,
    required this.tipo,
    required this.descripcion,
    required this.fecha,
    required this.usuarioId,
  });

  // Convierte la instancia a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'tipo': tipo,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'usuarioId': usuarioId,
    };
  }

  // Crea una instancia desde un mapa de Firestore
  factory SalidaMontana.fromMap(Map<String, dynamic> map) {
    return SalidaMontana(
      titulo: map['titulo'] ?? '',
      tipo: map['tipo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      fecha: DateTime.parse(map['fecha']),
      usuarioId: map['usuarioId'] ?? '',
    );
  }

  // Crea una instancia desde un documento de Firestore
  factory SalidaMontana.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SalidaMontana(
      titulo: data['titulo'] ?? '',
      tipo: data['tipo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      fecha: DateTime.parse(data['fecha']),
      usuarioId: data['usuarioId'] ?? '',
    );
  }
}
