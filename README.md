# Plant Care Management Application
<img src="https://upen.milaulas.com/pluginfile.php/1/core_admin/logocompact/300x300/1647098022/89925310_2623778167869379_5016977600837320704_n.jpg" alt="Descripción de la imagen" width="600">
<p><strong>Your Name </strong>Luis Enrique Campos Ontiveros, Diego Llamas Alcantar </p>
<p><strong>Course:</strong> Mobile Applications 2</p>
<p><strong>Submission: </strong>October 28, 2024</p>
<p><strong>Instructor's Name: </strong> Carlos Alberto Iriarte Mrtinez</p>
<h1> Introduction</h1>

<p>This application is designed to help users manage the care of their plants. Users can register each plant, view relevant information, and receive reminders for tasks such as watering, pruning, and other maintenance activities.</p>

<p>The application includes authentication via Supabase. There are two types of roles:</p>
<ul>
  <li><strong>User:</strong> can view plants and their care tasks.</li>
  <li><strong>Administrator:</strong> has permissions to create, modify, view, and delete plants and tasks. Additionally, the administrator can add new plant species to the database.</li>
</ul>

<p>Each plant includes detailed information such as common name, scientific name, family or species, type of plant (vegetable or fruit), size, and distinctive features. To make searching easier, users can apply filters by species or type of plant.</p>
<h1> Application Objective</h1>
<p>
    The plant care management application aims to allow users to register their plants and receive notifications on how to take proper care of them For this, it includes authentication with Supabase that allows for two different roles users who can view their plants and administrators who have the ability to create modify view and delete plants In addition the application will feature a CRUD system to manage plants and care tasks such as watering or pruning Each plant must include information such as its common name scientific name family or species type of plant which can be vegetable or fruit size and a distinctive characteristic It will also implement the option to filter plants by species or type which will facilitate the search and management of them Administrators will have the authority to add new plant species to the system thus enriching the database and enhancing the user experience
</p>
<h1>System Requirements for the Plant Care Management Application</h1>
<p>
    The application will be developed using Flutter, allowing for an attractive and functional user interface on both iOS and Android devices. Authentication will be implemented with Supabase to manage user access. There will be a user role for users to view their plants and an administrator role that will allow creating, modifying, viewing, and deleting plants.
</p>
<p>
    A database will store information about the plants and care tasks. Each plant entry must include its common name, scientific name, family or species, type of plant which can be a vegetable or fruit, size, and distinctive characteristic.
</p>
<p>
    There will be a CRUD system to allow administrators to manage the plants and care tasks such as watering and pruning, as well as an option for administrators to add new plant species to the system.
</p>
<p>
    Filters will be implemented so that users can search for plants by species or type, facilitating the management and search for them. Additionally, there will be a notification system to inform users about the proper care of their plants.
</p>
<h1>Application Description</h1>
<p>
    The plant care management application allows users to register their plants and receive notifications on proper care
</p>
<p>
    The application includes authentication with Supabase
    There will be a user role that allows users to view their plants and an administrator role that allows creating modifying viewing and deleting plants
</p>
<p>
    There will be a CRUD system to manage the plants and care tasks such as watering and pruning
    Each plant must contain its common name scientific name family or species type of plant which can be vegetable or fruit size and distinctive characteristic
</p>
<p>
    Administrators will have the ability to add new plant species to the system
    Additionally a filter will be implemented so that users can search for plants by species or type
</p>
  <h1>Source Code</h1>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
</head>
<body>
    <h2>Login</h2>
    <pre>
        <code class="language-dart">
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'administrador.dart';
import 'usuario.dart';
import 'registro.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future&lt;void&gt; _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Autenticación con correo y contraseña
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response != null) {
        // Obtener el perfil del usuario y su rol
        final userId = response.user!.id;
        final profile = await _supabase
            .from('profiles')
            .select('role')
            .eq('id', userId)
            .single();

        final role = profile['role'];

        // Redirigir según el rol
        if (role == 'Administrador') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdministradorPage()),
          );
        } else if (role == 'Usuario') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UsuarioPage()),
          );
        } else {
          throw 'Rol no reconocido';
        }
      }
    } catch (error) {
      print('Error de autenticación: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar Sesión'),
            ),
            ElevatedButton(onPressed: () {
            // Navega a la página de registro
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
          child: Text('Ir a Registro'),)
          ],
        ),
      ),
    );
  }
}
        </code>
    </pre>
</body>
</html>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>
<body>
    <h1>Administrador</h1>
    <pre>
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';  // Asegúrate de importar la página de login

class AdministradorPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página del Administrador'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Cerrar sesión dentro del onPressed
              await _supabase.auth.signOut(); 
              // Redirigir al login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenido Diseñador', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
    </pre>
</body>
</html>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
</head>
<body>
    <h2>Main</h2>
    <pre><code>
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'administrador.dart';
import 'usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nusnfloqgrgssxfvmkeo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51c25mbG9xZ3Jnc3N4ZnZta2VvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg0OTIxNjksImV4cCI6MjA0NDA2ODE2OX0.dkbMLuU70LiN5dgcZcsy5WC16ZMwLRCPukSVvNWXUIs',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = [];
  TextEditingController textController = TextEditingController();
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de cuidado de plantas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Ingrese un elemento',
              ),
              onSubmitted: (value) {
                // Crear
                if (value.isNotEmpty) {
                  setState(() {
                    items.add(value);
                    textController.clear();
                  });
                }
              },
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Crear
                  if (textController.text.isNotEmpty) {
                    setState(() {
                      items.add(textController.text);
                      textController.clear();
                    });
                  }
                },
                child: Text('Crear'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Actualizar
                  if (selectedIndex != null) {
                    setState(() {
                      items[selectedIndex!] = textController.text;
                      textController.clear();
                      selectedIndex = null;
                    });
                  }
                },
                child: Text('Actualizar'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Eliminar
                  if (selectedIndex != null && selectedIndex! < items.length) {
                    setState(() {
                      items.removeAt(selectedIndex!);
                      textController.clear();
                      selectedIndex = null;
                    });
                  }
                },
                child: Text('Eliminar'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(items[index]),
                  onTap: () {
                    // Leer y seleccionar para actualizar/eliminar
                    setState(() {
                      textController.text = items[index];
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
}
    </code></pre>
</body>
</html>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <h2>Record</h2>
    <pre><code>
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _roleController.text;

    try {
      // Crear usuario en Supabase auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final userId = response.user?.id;

      if (userId != null) {
        // Insertar el rol en la tabla de perfiles
        await _supabase.from('profiles').insert({
          'id': userId,
          'role': role, // alumno o maestro
        });

        print('Usuario registrado exitosamente con rol: $role');
      }
    } catch (error) {
      print('Error al registrar usuario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Rol (alumno o maestro)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
    </code></pre>
</body>
</html>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
</head>
<body>
    <h2>Plant list</h2>
    <pre><code>
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantListPage extends StatefulWidget {
  @override
  _PlantListPageState createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  List<dynamic> plants = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scientificNameController = TextEditingController();
  final TextEditingController _familyController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _distinctiveFeatureController = TextEditingController();
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    final response = await Supabase.instance.client.from('plants').select().execute();
    if (response.error == null) {
      setState(() {
        plants = response.data;
      });
    }
  }

  Future<void> addPlant() async {
    final response = await Supabase.instance.client.from('plants').insert({
      'nombre_comun': _nameController.text,
      'nombre_cientifico': _scientificNameController.text,
      'familia': _familyController.text,
      'tipo': _typeController.text,
      'tamaño': _sizeController.text,
      'caracteristica_distintiva': _distinctiveFeatureController.text,
    }).execute();
    
    if (response.error == null) {
      fetchPlants();
      clearInputs();
    }
  }

  Future<void> updatePlant(String id) async {
    final response = await Supabase.instance.client.from('plants').update({
      'nombre_comun': _nameController.text,
      'nombre_cientifico': _scientificNameController.text,
      'familia': _familyController.text,
      'tipo': _typeController.text,
      'tamaño': _sizeController.text,
      'caracteristica_distintiva': _distinctiveFeatureController.text,
    }).eq('id', id).execute();

    if (response.error == null) {
      fetchPlants();
      clearInputs();
    }
  }

  Future<void> deletePlant(String id) async {
    final response = await Supabase.instance.client.from('plants').delete().eq('id', id).execute();
    if (response.error == null) {
      fetchPlants();
    }
  }

  void clearInputs() {
    _nameController.clear();
    _scientificNameController.clear();
    _familyController.clear();
    _typeController.clear();
    _sizeController.clear();
    _distinctiveFeatureController.clear();
    selectedIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Plantas')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Nombre Común')),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(controller: _scientificNameController, decoration: InputDecoration(labelText: 'Nombre Científico')),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(controller: _familyController, decoration: InputDecoration(labelText: 'Familia')),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(controller: _typeController, decoration: InputDecoration(labelText: 'Tipo')),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(controller: _sizeController, decoration: InputDecoration(labelText: 'Tamaño')),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(controller: _distinctiveFeatureController, decoration: InputDecoration(labelText: 'Características Distintivas')),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: addPlant, child: Text('Agregar')),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (selectedIndex != null) {
                    updatePlant(plants[selectedIndex!]['id']);
                  }
                },
                child: Text('Actualizar'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (selectedIndex != null) {
                    deletePlant(plants[selectedIndex!]['id']);
                  }
                },
                child: Text('Eliminar'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plants.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(plants[index]['nombre_comun']),
                  subtitle: Text(plants[index]['nombre_cientifico']),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      _nameController.text = plants[index]['nombre_comun'];
                      _scientificNameController.text = plants[index]['nombre_cientifico'];
                      _familyController.text = plants[index]['familia'];
                      _typeController.text = plants[index]['tipo'];
                      _sizeController.text = plants[index]['tamaño'];
                      _distinctiveFeatureController.text = plants[index]['caracteristica_distintiva'];
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
}
    </code></pre>
</body>
</html>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <h2>User</h2>
    <pre><code>
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';  // Asegúrate de importar la página de 

class UsuarioPage extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página del Usuario'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Cerrar sesión dentro del onPressed
              await _supabase.auth.signOut(); 
              // Redirigir al login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenido Usuario', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
    </code></pre>
</body>
</html>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
</head>
<body>
    <h2>Plant filtration</h2>
    <p></p>
    <pre><code>
import 'package:flutter/material.dart';

import 'Listado_de_plantas.dart';

class _PlantListPageState extends State<PlantListPage> {
  // ... Código anterior ...

  String filter = "";
  
  get plants => null;

  @override
  Widget build(BuildContext context) {
    final filteredPlants = plants.where((plant) {
      return plant['nombre_comun'].toLowerCase().contains(filter.toLowerCase()) ||
            plant['tipo'].toLowerCase().contains(filter.toLowerCase());
    }).toList();

    return Scaffold(
      // ... Código anterior ...
      body: Column(
        children: [
          // Campo de texto para el filtro
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Filtrar por nombre o tipo'),
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlants.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredPlants[index]['nombre_comun']),
                  subtitle: Text(filteredPlants[index]['nombre_cientifico']),
                  onTap: () {
                    // Similar a la lógica anterior
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
    </code></pre>

    
</body>
</html>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
</head>
<body>
    <h1>Conclusion</h1>
    <p>
        The creation of the plant care management application has brought several challenges during development. From user authentication with Supabase to creating a user-friendly interface, every part of the code requires careful attention and constant testing.
    </p>
    <p>
        One of the biggest issues has been managing user roles. Ensuring that administrators can create, modify, and delete plants, while regular users can only view their own plants, has required detailed planning. This meant we had to implement conditions and validations in the code so that each user has access only to what they need.
    </p>
    <p>
        Additionally, developing the CRUD (Create, Read, Update, Delete) functions for plants and care tasks has been a challenge. The complexity increased when trying to organize information about each plant, which includes the common name, scientific name, type of plant, and distinctive features. Using Supabase as the database also presented its own difficulties, as we needed to understand how it works and what its limitations are.
    </p>
    <p>
        Implementing filters to search for plants by species or type has also added more complexity to the system. Not only did we have to develop the appropriate logic to filter the data, but we also had to ensure that the user interface was easy to understand and use so that users could take advantage of this feature without any issues.
    </p>
</body>
</html>



