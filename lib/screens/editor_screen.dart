import 'package:flutter/material.dart';
import '../models/notion_page.dart';

class EditorScreen extends StatefulWidget {
  final NotionPage page;

  const EditorScreen({super.key, required this.page});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NotionPage _editedPage;
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editedPage = NotionPage(
      id: widget.page.id,
      title: widget.page.title,
      content: widget.page.content,
      todos: List.from(widget.page.todos),
      category: widget.page.category,
      createdAt: widget.page.createdAt,
      updatedAt: widget.page.updatedAt,
      isFavorite: widget.page.isFavorite,
    );

    _titleController = TextEditingController(text: _editedPage.title);
    _contentController = TextEditingController(text: _editedPage.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  void _savePage() {
    _editedPage.title = _titleController.text.isEmpty
        ? 'Sin título'
        : _titleController.text;
    _editedPage.content = _contentController.text;
    _editedPage.updateTimestamp();

    Navigator.pop(context, _editedPage);
  }

  void _addTodoItem() {
    if (_todoController.text.trim().isEmpty) return;

    setState(() {
      _editedPage.todos.add(
        TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _todoController.text.trim(),
        ),
      );
      _todoController.clear();
    });
  }

  void _toggleTodo(TodoItem todo) {
    setState(() {
      todo.isCompleted = !todo.isCompleted;
    });
  }

  void _deleteTodo(TodoItem todo) {
    setState(() {
      _editedPage.todos.removeWhere((t) => t.id == todo.id);
    });
  }

  void _changeCategory(PageCategory newCategory) {
    setState(() {
      _editedPage.category = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editedPage.category == PageCategory.note
              ? 'Editar Nota'
              : _editedPage.category == PageCategory.task
                  ? 'Editar Tarea'
                  : 'Editar Idea',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _savePage,
            tooltip: 'Guardar',
          ),
          PopupMenuButton<PageCategory>(
            icon: Icon(_editedPage.category.icon),
            tooltip: 'Cambiar categoría',
            onSelected: _changeCategory,
            itemBuilder: (context) => PageCategory.values.map((category) {
              return PopupMenuItem(
                value: category,
                child: Row(
                  children: [
                    Icon(category.icon, color: category.color),
                    const SizedBox(width: 8),
                    Text(category.name),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de título
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Título',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Chip de categoría
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _editedPage.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _editedPage.category.color.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _editedPage.category.icon,
                      size: 16,
                      color: _editedPage.category.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _editedPage.category.name,
                      style: TextStyle(
                        color: _editedPage.category.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Sección de contenido de texto
              if (_editedPage.category != PageCategory.task) ...[
                const Text(
                  'Contenido',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu contenido aquí...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Sección de tareas/checklist
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lista de tareas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_editedPage.todos.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_editedPage.completedTodos}/${_editedPage.todos.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Campo para agregar nueva tarea
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: 'Agregar tarea...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _addTodoItem(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addTodoItem,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Lista de tareas
              if (_editedPage.todos.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.checklist,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No hay tareas aún',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _editedPage.todos.length,
                  itemBuilder: (context, index) {
                    final todo = _editedPage.todos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (_) => _toggleTodo(todo),
                        ),
                        title: Text(
                          todo.text,
                          style: TextStyle(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.isCompleted
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteTodo(todo),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
