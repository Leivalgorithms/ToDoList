import 'package:flutter_test/flutter_test.dart';
import 'package:mini_notion/models/notion_page.dart';

void main() {
  group('NotionPage', () {
    test('se crea con valores por defecto correctos', () {
      final page = NotionPage(id: '1', title: 'Test');

      expect(page.content, '');
      expect(page.todos, isEmpty);
      expect(page.isFavorite, false);
      expect(page.category, PageCategory.note);
    });

    test('preview muestra contenido cuando existe', () {
      final page = NotionPage(id: '1', title: 'Test', content: 'Hola mundo');

      expect(page.preview, 'Hola mundo');
    });

    test('preview muestra "Sin contenido" cuando está vacío', () {
      final page = NotionPage(id: '1', title: 'Test');

      expect(page.preview, 'Sin contenido');
    });

    test('preview trunca contenido mayor a 100 caracteres', () {
      final page = NotionPage(
        id: '1',
        title: 'Test',
        content: 'A' * 150,
      );

      expect(page.preview.length, lessThanOrEqualTo(103)); // 100 + '...'
      expect(page.preview.endsWith('...'), true);
    });

    test('preview muestra cantidad de tareas cuando no hay contenido', () {
      final page = NotionPage(
        id: '1',
        title: 'Test',
        todos: [
          TodoItem(id: '1', text: 'Tarea 1'),
          TodoItem(id: '2', text: 'Tarea 2'),
        ],
      );

      expect(page.preview, '2 tareas');
    });

    test('completedTodos cuenta correctamente las tareas completadas', () {
      final page = NotionPage(
        id: '1',
        title: 'Test',
        todos: [
          TodoItem(id: '1', text: 'Tarea 1', isCompleted: true),
          TodoItem(id: '2', text: 'Tarea 2', isCompleted: false),
          TodoItem(id: '3', text: 'Tarea 3', isCompleted: true),
        ],
      );

      expect(page.completedTodos, 2);
    });

    test('completedTodos retorna 0 cuando no hay tareas completadas', () {
      final page = NotionPage(
        id: '1',
        title: 'Test',
        todos: [
          TodoItem(id: '1', text: 'Tarea 1'),
        ],
      );

      expect(page.completedTodos, 0);
    });

    test('updateTimestamp actualiza updatedAt', () async {
      final page = NotionPage(id: '1', title: 'Test');
      final before = page.updatedAt;

      await Future.delayed(const Duration(milliseconds: 10));
      page.updateTimestamp();

      expect(page.updatedAt.isAfter(before), true);
    });
  });

  group('TodoItem', () {
    test('se crea con isCompleted en false por defecto', () {
      final todo = TodoItem(id: '1', text: 'Mi tarea');

      expect(todo.isCompleted, false);
    });

    test('se puede crear completado', () {
      final todo = TodoItem(id: '1', text: 'Mi tarea', isCompleted: true);

      expect(todo.isCompleted, true);
    });
  });

  group('PageCategory', () {
    test('cada categoría tiene nombre correcto', () {
      expect(PageCategory.note.name, 'Nota');
      expect(PageCategory.task.name, 'Tarea');
      expect(PageCategory.idea.name, 'Ideas');
    });
  });
}
