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

### **Conclusion:**
Developing the Pet Tracker application brought several challenges, including:

Role Management: Differentiating functionality for users and administrators required careful planning.
Supabase Integration: Learning Supabase for authentication and database operations was critical.
UI Design: Ensuring the interface was intuitive for users to easily manage their pets.
The result is a robust and scalable application that addresses the needs of pet owners and administrators. With features like role-based access, CRUD operations, and filtering, the Pet Tracker app provides a comprehensive solution for pet care management.
