# Pet Tracker Application

**Your Name:** Luis Enrique Campos Ontiveros, Diego Llamas Alcantar  
**Course:** Mobile Applications 2  
**Submission Date:** October 28, 2024  
**Instructor's Name:** Carlos Alberto Iriarte Martinez  

---

## Introduction

The Pet Tracker application is designed to help pet owners monitor and manage the care of their pets. Users can register pets, view relevant information, and track activities such as vaccinations, medical appointments, and feeding schedules. 

The application features authentication using Supabase, with two types of roles:

- **User:** Can view their pets and manage pet-related activities.
- **Administrator:** Has permissions to create, modify, view, and delete pets and activities. Administrators can also add new types of pets or update existing categories.

Each pet includes detailed information such as name, species, breed, age, and distinctive features. Users can also filter pets by species or other attributes for easy management.

---

## Application Objective

The primary goal of the Pet Tracker application is to provide an intuitive tool for pet owners to maintain and monitor their pets' care. This includes:

- **Authentication:** Secure login with Supabase for role-based access.
- **CRUD System:** Functionality to create, read, update, and delete pet records and care activities.
- **Filtering:** Options to filter pets by attributes such as species or breed for better organization.
- **Notifications:** Alerts for upcoming appointments or care tasks.

The app ensures user-friendliness for both casual pet owners and administrators managing a large number of pets.

---

## System Requirements

The application is developed using Flutter to ensure compatibility and responsiveness on both Android and iOS platforms. Authentication is powered by Supabase, which handles user roles and secure access to the database.

### Technical Stack:
- **Framework:** Flutter
- **Backend:** Supabase
- **Database:** Supabase PostgreSQL
- **Roles:** User and Administrator

---

## Application Description

The Pet Tracker application offers a clean interface for registering pets and managing their care. The following roles define the user experience:

### **User:**
- View their registered pets.
- Track activities like feeding, vaccination, and medical visits.

### **Administrator:**
- Manage all pet data, including adding, modifying, and deleting records.
- Add new pet categories or attributes.

The app employs a simple and user-friendly interface to ensure that users can navigate through features with ease.

---

## Source Code

Below is a brief overview of the main functionalities implemented in the application:

### **Login:**
Handles user authentication and role-based redirection.  
```dart
// Code snippet for Login
Future<void> _login() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  try {
    final response = await _supabase.auth.signInWithPassword(email: email, password: password);
    if (response != null) {
      final userId = response.user!.id;
      final profile = await _supabase.from('profiles').select('role').eq('id', userId).single();
      final role = profile['role'];

      if (role == 'Administrador') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdministradorPage()));
      } else if (role == 'Usuario') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UsuarioPage()));
      }
    }
  } catch (error) {
    print('Error de autenticación: $error');
  }
}
```

### **Main Functionality:**
Initializes the application and connects it to Supabase.
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://example.supabase.co',
    anonKey: 'your-anon-key',
  );

  runApp(MyApp());
}
```
### **CRUD for Pets:**
```dart
// Example: Adding a new pet
Future addPet() async {
  final response = await Supabase.instance.client.from('pets').insert({
    'name': _nameController.text,
    'species': _speciesController.text,
    'breed': _breedController.text,
    'age': _ageController.text,
    'features': _featuresController.text,
  }).execute();

  if (response.error == null) {
    fetchPets();
    clearInputs();
  }
}
```

### **Pet Filtering:**
```dart
String filter = "";
final filteredPets = pets.where((pet) {
  return pet['name'].toLowerCase().contains(filter.toLowerCase()) ||
         pet['species'].toLowerCase().contains(filter.toLowerCase());
}).toList();
```

### **Main:**
```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tviyvxjwaxdzcibdxzwm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR2aXl2eGp3YXhkemNpYmR4endtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1MTA0MDYsImV4cCI6MjA0NzA4NjQwNn0.v7P5Mi7cctbMg8jZADp_inqewb7-RnYDLRNRnr0S7UI',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Supabase Login',
      home: LoginPage(),
    );
  }
}
```

### **User:**
```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class UsuarioPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
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
              'Bienvenido Usuario',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.pets),
                  title: Text('Ver Datos de Mi Mascota'),
                  onTap: () {
                    // Navegar a la pantalla de visualización de datos de la mascota
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
```

### **Veterinario:**
```dart
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
```

### **pet_crud_screen:**
```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CrudPage extends StatefulWidget {
  CrudPage({super.key});

  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  List<Pet> pets = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController furController = TextEditingController();
  TextEditingController specialMarkController = TextEditingController();
  TextEditingController photoUrlController = TextEditingController();
  DateTime? selectedBirthDate;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD de Mascotas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre de la mascota'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: breedController,
              decoration: InputDecoration(labelText: 'Raza'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: furController,
              decoration: InputDecoration(labelText: 'Tipo de pelo'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: specialMarkController,
              decoration: InputDecoration(labelText: 'Seña Particular'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: photoUrlController,
              decoration: InputDecoration(labelText: 'URL de la foto'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedBirthDate = pickedDate;
                  });
                }
              },
              child: Text(
                selectedBirthDate == null
                    ? 'Seleccione la fecha de nacimiento'
                    : '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}',
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (validateInput()) {
                    setState(() {
                      pets.add(Pet(
                        name: nameController.text,
                        breed: breedController.text,
                        fur: furController.text,
                        specialMark: specialMarkController.text,
                        birthDate: selectedBirthDate!,
                        photoUrl: photoUrlController.text,
                        vaccines: [],
                      ));
                      clearFields();
                    });
                  }
                },
                child: Text('Crear'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (validateInput() && selectedIndex != null) {
                    setState(() {
                      pets[selectedIndex!] = Pet(
                        name: nameController.text,
                        breed: breedController.text,
                        fur: furController.text,
                        specialMark: specialMarkController.text,
                        birthDate: selectedBirthDate!,
                        photoUrl: photoUrlController.text,
                        vaccines: pets[selectedIndex!].vaccines,
                      );
                      clearFields();
                    });
                  }
                },
                child: Text('Actualizar'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (selectedIndex != null) {
                    setState(() {
                      pets.removeAt(selectedIndex!);
                      clearFields();
                    });
                  }
                },
                child: Text('Eliminar'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(pets[index].name),
                  subtitle: Text(
                    'Raza: ${pets[index].breed}, Pelo: ${pets[index].fur}, Nacimiento: ${pets[index].birthDate.day}/${pets[index].birthDate.month}/${pets[index].birthDate.year}',
                  ),
                  onTap: () {
                    setState(() {
                      nameController.text = pets[index].name;
                      breedController.text = pets[index].breed;
                      furController.text = pets[index].fur;
                      specialMarkController.text = pets[index].specialMark;
                      photoUrlController.text = pets[index].photoUrl;
                      selectedBirthDate = pets[index].birthDate;
                      selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool validateInput() {
    return nameController.text.isNotEmpty &&
        breedController.text.isNotEmpty &&
        furController.text.isNotEmpty &&
        specialMarkController.text.isNotEmpty &&
        photoUrlController.text.isNotEmpty &&
        selectedBirthDate != null;
  }

  void clearFields() {
    nameController.clear();
    breedController.clear();
    furController.clear();
    specialMarkController.clear();
    photoUrlController.clear();
    selectedBirthDate = null;
    selectedIndex = null;
  }
}

class Pet {
  String name;
  String breed;
  String fur;
  String specialMark;
  DateTime birthDate;
  String photoUrl;
  List<Vaccine> vaccines;

  Pet({
    required this.name,
    required this.breed,
    required this.fur,
    required this.specialMark,
    required this.birthDate,
    required this.photoUrl,
    required this.vaccines,
  });
}

class Vaccine {
  String name;
  DateTime date;

  Vaccine({
    required this.name,
    required this.date,
  });
}
```

## Conclusion

The development of the Pet Tracking Application has presented numerous challenges and learning opportunities. Implementing user authentication with Supabase, managing roles, and ensuring a seamless user experience required meticulous planning and execution. 

One of the most significant hurdles was designing a secure and scalable database structure that supports CRUD operations while maintaining data integrity. The role-based access system, which differentiates between users and administrators, also added complexity, demanding careful validation and control mechanisms.

Another challenge was creating an intuitive interface for filtering pets by breed or type, ensuring that users can efficiently manage their data. Additionally, understanding Supabase’s capabilities and integrating it into a Flutter application required research and troubleshooting.

Despite these challenges, the project demonstrated the potential of modern development tools and frameworks like Flutter and Supabase in creating robust, market-ready applications. Moving forward, the application is well-positioned for enhancements such as real-time notifications, offline support, and additional features to improve the user experience further.
