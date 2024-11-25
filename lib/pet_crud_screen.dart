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
