import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'veterinario.dart';
import 'user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _login() async {
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
        if (role == 'veterinario') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VeterinarioPage()),
          );
        } else if (role == 'user') {
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
          ],
        ),
      ),
    );
  }
}
