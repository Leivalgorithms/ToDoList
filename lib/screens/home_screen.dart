import 'package:flutter/material.dart';
import '../models/notion_page.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NotionPage> pages = [];
  PageCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    pages = [
      NotionPage(
        id: '1',
        title: 'Bienvenido a Mini Notion',
        content: 'Mi Primer Nota.',
        category: PageCategory.note,
      ),
      NotionPage(
        id: '2',
        title: 'Lista de compras',
        category: PageCategory.task,
        todos: [
          TodoItem(id: '1', text: 'Leche'),
          TodoItem(id: '2', text: 'Pan', isCompleted: true),
          TodoItem(id: '3', text: 'Huevos'),
        ],
      ),
      NotionPage(
        id: '3',
        title: 'Ideas para el proyecto',
        content:
            'Implementar sistema de búsqueda\nAñadir temas oscuros\nSincronización en la nube',
        category: PageCategory.idea,
        isFavorite: true,
      ),
    ];
  }

  List<NotionPage> get filteredPages {
    if (selectedCategory == null) {
      return pages;
    }
    return pages.where((page) => page.category == selectedCategory).toList();
  }

  void _createNewPage(PageCategory category) async {
    final newPage = NotionPage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Nueva ${category.name}',
      category: category,
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(page: newPage),
      ),
    );

    if (result != null && result is NotionPage) {
      setState(() {
        pages.insert(0, result);
      });
    }
  }

  void _editPage(NotionPage page) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(page: page),
      ),
    );

    if (result != null && result is NotionPage) {
      setState(() {
        final index = pages.indexWhere((p) => p.id == result.id);
        if (index != -1) {
          pages[index] = result;
        }
      });
    }
  }

  void _deletePage(NotionPage page) {
    setState(() {
      pages.removeWhere((p) => p.id == page.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${page.title} eliminada'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              pages.add(page);
            });
          },
        ),
      ),
    );
  }

  void _toggleFavorite(NotionPage page) {
    setState(() {
      page.isFavorite = !page.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Notion'),
        actions: [
          if (selectedCategory != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  selectedCategory = null;
                });
              },
              tooltip: 'Limpiar filtro',
            ),
        ],
      ),
      drawer: _buildDrawer(),
      body: filteredPages.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPages.length,
              itemBuilder: (context, index) {
                final page = filteredPages[index];
                return _buildPageCard(page);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        tooltip: 'Crear nueva página',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.book,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mini Notion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${pages.length} ${pages.length == 1 ? 'página' : 'páginas'}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Todas las páginas'),
            selected: selectedCategory == null,
            onTap: () {
              setState(() {
                selectedCategory = null;
              });
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading:
                Icon(PageCategory.note.icon, color: PageCategory.note.color),
            title: Text('${PageCategory.note.name}s'),
            trailing: Text(
              pages
                  .where((p) => p.category == PageCategory.note)
                  .length
                  .toString(),
            ),
            onTap: () {
              setState(() {
                selectedCategory = PageCategory.note;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:
                Icon(PageCategory.task.icon, color: PageCategory.task.color),
            title: Text('${PageCategory.task.name}s'),
            trailing: Text(
              pages
                  .where((p) => p.category == PageCategory.task)
                  .length
                  .toString(),
            ),
            onTap: () {
              setState(() {
                selectedCategory = PageCategory.task;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:
                Icon(PageCategory.idea.icon, color: PageCategory.idea.color),
            title: Text(PageCategory.idea.name),
            trailing: Text(
              pages
                  .where((p) => p.category == PageCategory.idea)
                  .length
                  .toString(),
            ),
            onTap: () {
              setState(() {
                selectedCategory = PageCategory.idea;
              });
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text('Favoritos'),
            trailing: Text(
              pages.where((p) => p.isFavorite).length.toString(),
            ),
            onTap: () {
              setState(() {
                selectedCategory = null;
              });
              Navigator.pop(context);
              // Aquí podrías filtrar por favoritos
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageCard(NotionPage page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _editPage(page),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    page.category.icon,
                    color: page.category.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      page.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      page.isFavorite ? Icons.star : Icons.star_border,
                      color: page.isFavorite ? Colors.amber : null,
                    ),
                    onPressed: () => _toggleFavorite(page),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deletePage(page),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                page.preview,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (page.todos.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${page.completedTodos}/${page.todos.length} completadas',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Text(
                _formatDate(page.updatedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            selectedCategory == null
                ? 'No hay páginas aún'
                : 'No hay ${selectedCategory!.name}s',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona el botón + para crear una',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear nueva página'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: PageCategory.values.map((category) {
            return ListTile(
              leading: Icon(category.icon, color: category.color),
              title: Text(category.name),
              onTap: () {
                Navigator.pop(context);
                _createNewPage(category);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inHours < 1) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inDays < 1) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
