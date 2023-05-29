import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/page_sign_up/widgets/autocomplete_address.dart';
import 'package:i2_i3_g9/app/page_login/view/login.dart';

import '../../models/pets.dart';
import '../../utils/constants.dart';
import '../../utils/network_util.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpState();
}

enum SingingCharacter { madame, monsieur }

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyPet = GlobalKey<FormState>();
  final TextEditingController _petName = TextEditingController();
  final TextEditingController _petAge = TextEditingController();
  final TextEditingController _petBreed = TextEditingController();
  final TextEditingController _petDescription = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();

  int selectedValue = 1;
  List<Pets> petsList = [];
  List<String> typeList = <String>[
    // List de choix pour le type d'animal
    'chien',
    'chat',
    'autre'
  ];
  String typeSelected = 'chien';
  int petTouched = -1;

  bool isValidName(String val) {
    if (val == null || val.isEmpty) {
      return false;
    }
    return true;
  }

  void selectPet(int ind) {
    setState(() {
      if (petTouched == ind) {
        petTouched = -1;
      } else {
        petTouched = ind;
      }
    });
  }

  void deletePetInList(int ind) {
    setState(() {
      petsList.removeAt(ind);
      petTouched = -1;
    });
  }

  Future<void> placeAutocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com",
        "maps/api/place/autocomplete/json", {"input": query, "key": apiKey});
    String? response = await NetworkUtils.fetchUrl(uri);
    if (response != null) {

    }
  }

  void valueChange(String value) {
    setState(() {
      placeAutocomplete(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    icon: const ImageIcon(AssetImage('assets/images/left.png')),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: selectedValue,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Theme.of(context).primaryColor),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = 1;
                          });
                        },
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Madame'),
                          onTap: () {
                            setState(() {
                              selectedValue = 1;
                            });
                          },
                        ),
                      ),
                      Radio(
                        value: 2,
                        groupValue: selectedValue,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Theme.of(context).primaryColor),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = 2;
                          });
                        },
                      ),
                      Expanded(
                          child: ListTile(
                        title: const Text('Monsieur'),
                        onTap: () {
                          setState(() {
                            selectedValue = 2;
                          });
                        },
                      )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            style: TextStyle(fontSize: screenHeight * 0.02),
                            decoration: InputDecoration(
                              labelText: 'Nom',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            style: TextStyle(fontSize: screenHeight * 0.02),
                            decoration: InputDecoration(
                              labelText: 'Prénom',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  AutoAddress(controllerAddress: _controllerAddress, valueChange: valueChange,),

                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(fontSize: screenHeight * 0.02),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(fontSize: screenHeight * 0.02),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(fontSize: screenHeight * 0.02),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Vérifier votre mot de passe',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(fontSize: screenHeight * 0.02),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Center(
                                child: Text(
                                  'Ajouter un compagnon 😸',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              content: Form(
                                key: _formKeyPet,
                                child: SizedBox(
                                  height: 500,
                                  child: ListView(
                                    children: [
                                      TextFormField(
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.02),
                                        validator: (value) {
                                          if (!isValidName(value!)) {
                                            print(!isValidName(value!));
                                            return 'Enter valid email';
                                          }
                                        },
                                        controller: _petName,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'Nom',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: _petAge,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.02),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Age',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: _petBreed,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.02),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'Race',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonFormField(
                                          // Sélection de son lieu de départ
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2.0),
                                            ),
                                            focusColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          value: typeSelected,
                                          // icon: Icon(getSelectionIcon(),
                                          //     size: 18, color: Theme.of(context).primaryColor),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          items: typeList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            typeSelected = value!;
                                          }),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: _petDescription,
                                        maxLines: 5,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.02),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'Description',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: Text(
                                    'Annuler',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // print(_formKeyPet.currentState!.validate());
                                    Pets pet = Pets(
                                        name: _petName.value.text,
                                        age: int.parse(_petAge.value.text),
                                        breed: _petBreed.value.text,
                                        description: _petDescription.value.text,
                                        referenceId: '',
                                        type: typeSelected);
                                    petsList.add(pet);

                                    Navigator.pop(context, 'OK');
                                  },
                                  child: Text(
                                    'Créer',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Chip(
                          label: Text(
                            '🦮 Ajouter',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(8),
                        itemCount: petsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              selectPet(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4.0),
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromRGBO(156, 136, 255, 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (petsList[index].type == 'chien')
                                      ? CircleAvatar(
                                          backgroundColor: petTouched == index
                                              ? Colors.greenAccent
                                              : const Color.fromRGBO(
                                                  113, 88, 226, 1),
                                          child: const Text(
                                            '🐶',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: petTouched == index
                                              ? Colors.greenAccent
                                              : const Color.fromRGBO(
                                                  113, 88, 226, 1),
                                          child: const Text(
                                            '😸',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    petsList[index].name,
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(height: 10),
                  (petTouched != -1)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Filled tonal icon button
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(162, 155, 254,
                                    1), // Set the background color here
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const ImageIcon(
                                    AssetImage('assets/images/pencil.png')),
                                onPressed: () {
                                  // Handle button press
                                },
                                color: Colors.white, // Set the icon color
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(255, 118, 117,
                                    0.8), // Set the background color here
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const ImageIcon(
                                    AssetImage('assets/images/trash.png')),
                                onPressed: () {
                                  deletePetInList(petTouched);
                                },
                                color: Colors.white, // Set the icon color
                              ),
                            )
                          ],
                        )
                      : const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // placeAutocomplete("3 avenue ernest ruben");
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Créer votre compte',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
