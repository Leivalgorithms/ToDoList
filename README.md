# 📱 Mini Notion - Organizador Personal

Una aplicación Flutter estilo Notion simplificada para organizar notas, tareas e ideas.

## ✨ Características

### Funcionalidades principales:
- ✅ **Crear, editar y eliminar páginas/notas**
- 📝 **Tres tipos de contenido**: Notas, Tareas e Ideas
- ☑️ **Lista de tareas (checklist)** con seguimiento de progreso
- ⭐ **Marcar páginas como favoritas**
- 🗂️ **Filtrar por categorías** usando el menú lateral (Drawer)
- 📅 **Timestamps automáticos** (actualización y creación)
- 🎨 **Interfaz Material Design 3**

### Widgets implementados:

#### Widgets básicos:
- `MaterialApp` - Configuración de la app
- `Scaffold` - Estructura base de las pantallas
- `AppBar` - Barra superior con título y acciones
- `Text` - Textos y títulos
- `Icon` - Iconos visuales

#### Widgets de Layout:
- `Column` - Organización vertical
- `Row` - Organización horizontal
- `Container` - Contenedor con decoración
- `Card` - Tarjetas para las notas
- `Padding` - Espaciado interno
- `ListView` - Lista scrolleable de elementos
- `SingleChildScrollView` - Scroll para contenido largo

#### Widgets de botones e interacción:
- `FloatingActionButton` - Botón flotante para crear
- `IconButton` - Botones con iconos
- `ElevatedButton` - Botón elevado
- `InkWell` - Efecto de toque
- `PopupMenuButton` - Menú contextual

#### Widgets de entrada de datos:
- `TextField` - Campo de texto simple
- `TextFormField` - Campo de texto para formularios
- `Checkbox` - Casillas de verificación para tareas

#### Widgets de listas:
- `ListView.builder` - Lista dinámica eficiente
- `ListTile` - Items de lista predefinidos

#### Widgets de navegación:
- `Navigator` - Navegación entre pantallas
- `Drawer` - Menú lateral deslizante

#### Widgets de estado:
- `StatefulWidget` - Widgets con estado mutable
- `StatelessWidget` - Widgets sin estado

#### Widgets visuales:
- `AlertDialog` - Diálogo de selección
- `SnackBar` - Notificación temporal
- `Divider` - Línea divisoria
- `Chip` (Container custom) - Etiqueta de categoría

## 🚀 Cómo ejecutar

### Prerrequisitos:
- Flutter SDK instalado (3.0.0 o superior)
- Un editor (VS Code, Android Studio, etc.)
- Emulador o dispositivo físico

### Pasos:

1. **Navega a la carpeta del proyecto:**
```bash
cd mini_notion
```

2. **Instala las dependencias:**
```bash
flutter pub get
```

3. **Ejecuta la aplicación:**

**En Web:**
```bash
flutter run -d chrome
```

**En dispositivo Android/iOS:**
```bash
flutter run
```

**En Windows:**
```bash
flutter run -d windows
```

**En macOS:**
```bash
flutter run -d macos
```

**En Linux:**
```bash
flutter run -d linux
```

## 📁 Estructura del proyecto

```
mini_notion/
├── lib/
│   ├── main.dart                 # Punto de entrada de la app
│   ├── models/
│   │   └── notion_page.dart      # Modelo de datos
│   └── screens/
│       ├── home_screen.dart      # Pantalla principal (lista)
│       └── editor_screen.dart    # Pantalla de edición
└── pubspec.yaml                  # Dependencias
```

## 🎯 Funcionalidades por pantalla

### Pantalla 1: Home (Dashboard)
- **Vista general** de todas las páginas
- **Drawer** con navegación por categorías
- **Tarjetas** que muestran preview, categoría y progreso
- **Botón flotante** para crear nuevas páginas
- **Filtrado** por categoría
- **Eliminar páginas** con opción de deshacer
- **Favoritos** mediante icono de estrella

### Pantalla 2: Editor
- **Campo de título** editable
- **Selector de categoría** (Nota/Tarea/Idea)
- **Área de contenido** para texto libre
- **Lista de tareas** con checkboxes
- **Agregar/eliminar** items de tareas
- **Guardar automático** al volver

## 🎨 Categorías de páginas

1. **📝 Notas** (Azul)
   - Para contenido de texto libre
   - Notas generales, apuntes, etc.

2. **☑️ Tareas** (Verde)
   - Enfocadas en checklists
   - Seguimiento de progreso

3. **💡 Ideas** (Naranja)
   - Para brainstorming
   - Conceptos y proyectos futuros

## 💡 Ideas para extender el proyecto

- Persistencia de datos (SharedPreferences o SQLite)
- Búsqueda de páginas
- Ordenar por fecha, nombre, etc.
- Temas claros/oscuros
- Etiquetas personalizadas
- Exportar/importar notas
- Recordatorios para tareas
- Sincronización en la nube

## 📝 Notas para el video de demostración

### Puntos clave a mostrar:

1. **Navegación entre pantallas** (Navigator)
2. **Drawer funcional** con filtros
3. **Diferentes tipos de widgets** en acción
4. **TextField** para entrada de datos
5. **Checkbox** interactivo para tareas
6. **ListView** dinámico
7. **Cards** personalizadas
8. **Botones** (FloatingActionButton, IconButton, ElevatedButton)
9. **Estado** (marcar favoritos, completar tareas)
10. **Feedback visual** (SnackBar al eliminar)

### Flujo sugerido para el video:

1. Mostrar pantalla principal vacía/con datos
2. Abrir Drawer y explicar categorías
3. Crear nueva página (mostrar AlertDialog)
4. Editar título y contenido
5. Agregar tareas y marcarlas como completadas
6. Cambiar categoría desde el PopupMenu
7. Volver y ver la página en la lista
8. Marcar como favorita
9. Filtrar por categorías
10. Eliminar y deshacer

---

**Desarrollado con Flutter 💙**
