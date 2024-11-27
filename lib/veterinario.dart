import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class VeterinarioPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Veterinario'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _supabase.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bienvenido Veterinario',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Agregar Mascota'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(action: 'add'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Editar Mascota'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(action: 'edit'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Borrar Mascota'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(action: 'delete'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.pets),
                  title: Text('Ver Mascotas'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(action: 'view'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String action;

  MyHomePage({required this.action});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _furController = TextEditingController();
  final TextEditingController _specialMarkController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();
  DateTime? _birthDate;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acción: ${widget.action}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.action != 'view')
              Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: _breedController,
                    decoration: InputDecoration(labelText: 'Raza'),
                  ),
                  TextField(
                    controller: _furController,
                    decoration: InputDecoration(labelText: 'Tipo de pelo'),
                  ),
                  TextField(
                    controller: _specialMarkController,
                    decoration: InputDecoration(labelText: 'Seña particular'),
                  ),
                  TextField(
                    controller: _photoUrlController,
                    decoration: InputDecoration(labelText: 'URL de foto'),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _birthDate = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      _birthDate == null
                          ? 'Seleccione la fecha de nacimiento'
                          : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (widget.action == 'add') {
                        // Agregar mascota
                        if (_nameController.text.isNotEmpty &&
                            _breedController.text.isNotEmpty &&
                            _furController.text.isNotEmpty &&
                            _specialMarkController.text.isNotEmpty &&
                            _photoUrlController.text.isNotEmpty &&
                            _birthDate != null) {
                          await _supabase.from('pets').insert({
                            'name': _nameController.text,
                            'breed': _breedController.text,
                            'fur': _furController.text,
                            'special_mark': _specialMarkController.text,
                            'birth_date': _birthDate!.toIso8601String(),
                            'photo_url': _photoUrlController.text,
                          }).select();
                          _clearFields();
                          Navigator.pop(context);
                        }
                      } else if (widget.action == 'edit') {
                        // Editar mascota
                        // Implementar edición de mascota aquí
                      } else if (widget.action == 'delete') {
                        // Borrar mascota
                        // Implementar borrado de mascota aquí
                      }
                    },
                    child: Text(widget.action == 'add' ? 'Guardar' : 'Actualizar'),
                  ),
                ],
              ),
            if (widget.action == 'view')
              Expanded(
                child: FutureBuilder(
                  future: _supabase.from('pets').select().select(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('No hay mascotas registradas.'));
                    } else {
                      final pets = snapshot.data as List<dynamic>;
                      return ListView.builder(
                        itemCount: pets.length,
                        itemBuilder: (context, index) {
                          final pet = pets[index];
                          return ListTile(
                            leading: Image.network(pet['photo_url']),
                            title: Text(pet['name']),
                            subtitle: Text(
                                'Raza: ${pet['breed']}, Fecha de nacimiento: ${pet['birth_date']}'),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _breedController.clear();
    _furController.clear();
    _specialMarkController.clear();
    _photoUrlController.clear();
    _birthDate = null;
  }
}
