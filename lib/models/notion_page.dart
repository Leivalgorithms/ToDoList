import 'package:flutter/material.dart';

class NotionPage {
  String id;
  String title;
  String content;
  List<TodoItem> todos;
  DateTime createdAt;
  DateTime updatedAt;
  PageCategory category;
  bool isFavorite;

  NotionPage({
    required this.id,
    required this.title,
    this.content = '',
    List<TodoItem>? todos,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.category = PageCategory.note,
    this.isFavorite = false,
  })  : todos = todos ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Obtener un preview del contenido (primeras 100 caracteres)
  String get preview {
    if (content.isEmpty && todos.isEmpty) {
      return 'Sin contenido';
    }
    if (content.isNotEmpty) {
      return content.length > 100 ? '${content.substring(0, 100)}...' : content;
    }
    return '${todos.length} ${todos.length == 1 ? 'tarea' : 'tareas'}';
  }

  // Contar tareas completadas
  int get completedTodos => todos.where((todo) => todo.isCompleted).length;

  // Actualizar timestamp
  void updateTimestamp() {
    updatedAt = DateTime.now();
  }
}

class TodoItem {
  String id;
  String text;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.text,
    this.isCompleted = false,
  });
}

enum PageCategory {
  note,
  task,
  idea,
}

extension PageCategoryExtension on PageCategory {
  String get name {
    switch (this) {
      case PageCategory.note:
        return 'Nota';
      case PageCategory.task:
        return 'Tarea';
      case PageCategory.idea:
        return 'Ideas';
    }
  }

  IconData get icon {
    switch (this) {
      case PageCategory.note:
        return Icons.article;
      case PageCategory.task:
        return Icons.checklist;
      case PageCategory.idea:
        return Icons.lightbulb;
    }
  }

  Color get color {
    switch (this) {
      case PageCategory.note:
        return Colors.blue;
      case PageCategory.task:
        return Colors.green;
      case PageCategory.idea:
        return Colors.orange;
    }
  }
}
