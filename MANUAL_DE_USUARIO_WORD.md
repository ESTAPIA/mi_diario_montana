Manual de Usuario - Mi Diario de Montaña

Introducción

Mi Diario de Montaña es una aplicación móvil que te permite registrar, organizar y gestionar todas tus aventuras en la montaña. Desde trekking hasta escalada, mantén un registro completo de tus experiencias al aire libre.

Características principales:
• Registro de salidas con detalles completos
• Búsqueda y filtrado de actividades
• Edición y eliminación de registros
• Vista general de todas tus aventuras
• Autenticación segura con Firebase

Requisitos del Sistema

Dispositivos compatibles:
• Android: Versión 5.0 (API 21) o superior
• Conexión a internet para sincronización

Para desarrolladores:
• Flutter 3.0+
• Dart 2.17+
• Firebase configurado

Instalación y Configuración

Opción 1: Descargar ZIP desde GitHub
1. Ve al repositorio: https://github.com/ESTAPIA/mi_diario_montana
2. Haz clic en el botón verde "Code"
3. Selecciona "Download ZIP"
4. Extrae el archivo ZIP en tu computadora
5. Sigue las instrucciones para desarrolladores (Opción 2)

Opción 2: Para desarrolladores
# Clonar el repositorio
git clone https://github.com/ESTAPIA/mi_diario_montana.git

# Navegar al directorio
cd mi_diario_montana

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run

Opción 3: APK (Próximamente)
En futuras versiones estará disponible un archivo APK listo para instalar directamente en dispositivos Android.

Primer Uso de la Aplicación

1. Pantalla de Bienvenida
Al abrir la aplicación por primera vez, verás la pantalla de Iniciar Sesión.

[INSERTAR IMAGEN: login_screen.png]

Elementos:
• Logo de la aplicación
• Campo para correo electrónico
• Campo para contraseña
• Botón "Iniciar Sesión"
• Enlace "¿No tienes cuenta? Regístrate"

2. Crear una Cuenta Nueva
Si es tu primera vez, toca "¿No tienes cuenta? Regístrate"

[INSERTAR IMAGEN: register_screen.png]

Pasos para registrarte:
1. Ingresa tu correo electrónico válido
2. Crea una contraseña (mínimo 6 caracteres)
3. Toca el botón "Registrarse"
4. ¡Serás redirigido automáticamente a la pantalla principal!

3. Iniciar Sesión
Si ya tienes cuenta:
1. Ingresa tu correo electrónico
2. Ingresa tu contraseña
3. Toca "Iniciar Sesión"

Tip: La app recordará tu sesión, no necesitarás iniciar sesión cada vez.

Pantalla Principal (Home)

[INSERTAR IMAGEN: home_screen.png]

Elementos principales:

Barra superior:
• Título "Inicio"
• Botón de cerrar sesión

Contenido principal:
• Saludo personalizado con tu email
• Botón "Registrar nueva salida"
• "Historial de salidas" con botón "Ver todo"
• Lista de tus salidas más recientes

¿Qué puedes hacer aquí?
• Ver un resumen de tus aventuras
• Acceder rápidamente a registrar nueva salida
• Ver tus últimas salidas registradas
• Navegar al historial completo
• Cerrar sesión de forma segura

Registrar Nueva Salida

[INSERTAR IMAGEN: registrar_salida.png]

Pasos para registrar una salida:

1. Título: Ingresa un nombre descriptivo
   Ejemplo: "Ascenso al Cerro Aconcagua"

2. Tipo de actividad: Selecciona del menú desplegable
   • Trekking
   • Senderismo
   • Escalada
   • Ciclismo
   • Camping

3. Descripción: Detalla tu experiencia
   Ejemplo: "Hermoso día de trekking por 8 horas. Clima despejado y vista espectacular desde la cima."

4. Fecha: Toca el campo de fecha y selecciona
   Se abrirá un calendario para elegir el día

5. Guardar: Toca "Registrar salida"

Validaciones:
• Todos los campos son obligatorios
• El título no puede estar vacío
• Debe seleccionar un tipo de actividad
• La descripción es requerida
• Debe elegir una fecha

Historial de Salidas

[INSERTAR IMAGEN: historial_screen.png]

Funcionalidades disponibles:

Búsqueda:
• Escribe en el campo "Buscar salidas..."
• Busca por título o descripción
• Los resultados se filtran en tiempo real

Filtros:
• Desplegable "Filtrar por tipo"
• Opciones: Todos, Trekking, Senderismo, Escalada, Ciclismo, Camping
• Combina con la búsqueda para resultados precisos

Lista de salidas:
Cada salida muestra:
• Inicial del tipo de actividad
• Título de la salida
• Tipo de actividad
• Fecha de la salida

Acciones rápidas:
• Toca cualquier salida para ver detalles completos
• Botón "+" para agregar nueva salida

Ver Detalles de Salida

[INSERTAR IMAGEN: detalle_salida.png]

Información mostrada:
• Título completo
• Tipo de actividad (con icono)
• Fecha (con icono de calendario)
• Descripción completa

Acciones disponibles:
Barra superior:
• Editar: Modificar la información
• Eliminar: Borrar la salida (con confirmación)

Editar Salida

[INSERTAR IMAGEN: editar_salida.png]

Proceso de edición:

1. Formulario pre-cargado: Todos los campos mostrarán la información actual
2. Modificar: Cambia cualquier campo que desees
3. Guardar: Toca el botón "Actualizar salida" o el icono en la barra superior

Validaciones:
• Mismas validaciones que al crear
• Los cambios se guardan inmediatamente
• Regresa automáticamente a la pantalla de detalles
• Mensaje de confirmación: "¡Salida actualizada exitosamente!"

Eliminar Salida

Proceso de eliminación segura:

1. Confirmación: Se muestra un diálogo de confirmación
   • Título: "Eliminar salida"
   • Mensaje: "¿Estás seguro de que deseas eliminar '[Nombre de la salida]'? Esta acción no se puede deshacer."
   
2. Opciones:
   • "Cancelar" - No elimina nada
   • "Eliminar" - Confirma la eliminación

3. Resultado:
   • Mensaje: "¡Salida eliminada exitosamente!"
   • Regresa automáticamente a la pantalla principal

Gestión de Sesión

Cerrar Sesión:
1. Toca el icono en la barra superior (pantalla principal)
2. Confirma la acción en el diálogo
3. Serás redirigido a la pantalla de login
4. Mensaje: "Sesión cerrada exitosamente"

Sesión automática:
• La app mantiene tu sesión iniciada
• No necesitas hacer login cada vez que abres la app
• Solo cerrarás sesión manualmente o si cambias de dispositivo

Notificaciones y Feedback

La aplicación utiliza un sistema de notificaciones para mantenerte informado:

Tipos de notificaciones:

Éxito (Verde):
• "¡Salida registrada exitosamente!"
• "¡Salida actualizada exitosamente!"
• "¡Bienvenido de vuelta!"

Error (Rojo):
• "Por favor completa todos los campos requeridos"
• "Error al guardar la salida. Intenta de nuevo."

Información (Azul):
• "Sesión cerrada exitosamente"

Casos de Uso Comunes

Caso 1: Registrar una nueva aventura
1. Abrir la app → Pantalla principal
2. Tocar "Registrar nueva salida"
3. Llenar todos los campos
4. Guardar
5. Listo - aparece en tu historial

Caso 2: Buscar una salida específica
1. Ir a "Historial de salidas"
2. Usar el campo de búsqueda
3. Escribir palabras clave (ej: "cerro", "escalada")
4. Ver resultados filtrados

Caso 3: Editar información incorrecta
1. Buscar la salida en el historial
2. Tocar para ver detalles
3. Tocar el icono "Editar"
4. Modificar la información
5. Guardar cambios

Caso 4: Eliminar salida antigua
1. Encontrar la salida
2. Ver detalles
3. Tocar "Eliminar"
4. Confirmar la acción
5. Eliminada permanentemente

Solución de Problemas

No puedo iniciar sesión
Posibles soluciones:
• Verifica tu conexión a internet
• Revisa que el email sea correcto
• Confirma que la contraseña tenga al menos 6 caracteres
• Si olvidaste tu contraseña, registra una cuenta nueva

No se guardan mis salidas
Posibles soluciones:
• Verifica conexión a internet
• Asegúrate de llenar todos los campos
• Cierra y abre la app nuevamente
• Revisa que tengas espacio de almacenamiento

La app se cierra inesperadamente
Posibles soluciones:
• Reinicia la aplicación
• Reinicia tu dispositivo
• Verifica que tengas la versión compatible del sistema
• Libera memoria del dispositivo

No aparecen mis salidas
Posibles soluciones:
• Verifica tu conexión a internet
• Asegúrate de estar en la cuenta correcta
• Espera unos segundos para la sincronización
• Intenta cerrar sesión y volver a iniciar

Soporte y Contacto

Repositorio del proyecto:
GitHub: https://github.com/ESTAPIA/mi_diario_montana

Reportar errores:
1. Ve al repositorio de GitHub
2. Crea un nuevo "Issue"
3. Describe el problema detalladamente
4. Incluye capturas de pantalla si es posible

Sugerir mejoras:
• Usa la sección "Issues" en GitHub
• Marca tu sugerencia como "enhancement"
• Describe claramente qué te gustaría que se agregue

Información Técnica

Versión: 1.0.0
Desarrollado con: Flutter & Firebase
Plataformas: Android
Desarrollado por: Estudiante PUCE
Repositorio: https://github.com/ESTAPIA/mi_diario_montana

Dependencias principales:
• Firebase Auth (autenticación)
• Cloud Firestore (base de datos)
• Material Design (interfaz)
• Font Awesome Flutter (iconos)
• Google Fonts (tipografías)

Configuración de Firebase:
• Proyecto: mi-diario-de-montana
• Autenticación habilitada
• Firestore Database configurado
• Reglas de seguridad implementadas

¡Disfruta tu experiencia!

Mi Diario de Montaña está diseñado para ser tu compañero perfecto en todas tus aventuras. Mantén un registro detallado de tus experiencias y revive esos momentos especiales cuando quieras.

¡Que tengas grandes aventuras!

Manual creado con amor para aventureros como tú
