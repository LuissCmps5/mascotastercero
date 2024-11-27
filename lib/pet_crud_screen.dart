import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tviyvxjwaxdzcibdxzwm.supabase.co',  // Reemplaza con tu URL de Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR2aXl2eGp3YXhkemNpYmR4endtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1MTA0MDYsImV4cCI6MjA0NzA4NjQwNn0.v7P5Mi7cctbMg8jZADp_inqewb7-RnYDLRNRnr0S7UI',  // Reemplaza con tu anon key de Supabase
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = getItems();
  }

  Future<void> createItem(String name, String description) async {
    final response = await Supabase.instance.client
        .from('items')
        .insert({
          'name': name,
          'description': description,
        })
        .select();
    
    if (response != 200) {
      print('Item created successfully');
      setState(() {
        _itemsFuture = getItems();
      });
    } else {
      print('Error creating item: ${response}');
    }
  }

  Future<List<dynamic>> getItems() async {
    final response = await Supabase.instance.client
        .from('items')
        .select()
        .select();

    if (response != 200) {
      return response as List<dynamic>;
    } else {
      print('Error fetching items: ${response}');
      return [];
    }
  }

  Future<void> updateItem(int id, String name, String description) async {
    final response = await Supabase.instance.client
        .from('items')
        .update({
          'name': name,
          'description': description,
        })
        .eq('id', id)
        .select();
    
    if (response != 200) {
      print('Item updated successfully');
      setState(() {
        _itemsFuture = getItems();
      });
    } else {
      print('Error updating item: ${response}');
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await Supabase.instance.client
        .from('items')
        .delete()
        .eq('id', id)
        .select();
    
    if (response != 200) {
      print('Item deleted successfully');
      setState(() {
        _itemsFuture = getItems();
      });
    } else {
      print('Error deleting item: ${response}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _itemsFuture = getItems();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data as List<dynamic>;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item['name']),
                subtitle: Text(item['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(item['id'], item['name'], item['description']);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(item['id']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog() {
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              _itemsFuture = getItems();
              await createItem(_nameController.text, _descriptionController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int id, String name, String description) {
    final _nameController = TextEditingController(text: name);
    final _descriptionController = TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await updateItem(id, _nameController.text, _descriptionController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Confirmation'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await deleteItem(id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}