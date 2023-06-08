import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/models/address.dart';
import 'package:i2_i3_g9/app/models/user.dart' as userdb;
import 'package:i2_i3_g9/app/repository/RidesRepository.dart';
import 'package:i2_i3_g9/app/utils/globals.dart';
import '../../models/pet.dart';
import '../../page_login/view/login.dart';
import '../../page_navbar/view/nav-bar.dart';
import '../../page_sign_up/widgets/autocomplete_address.dart';
import '../../repository/usersRepository.dart';

class settingPage extends StatefulWidget {
  settingPage({Key? key}) : super(key: key);

  // Récupération de la liste des animaux domestiques d'un utilisateur
  final Stream<QuerySnapshot> petsCollection =
      UsersRepository().getPetsOfUserStream(Globals().idUser);

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  int _selectedIndex = 3;
  int selectedValue = 1; // Selection du genre
  String petTouched = ''; // animal séléctionné
  bool addPet = false; // Vérifier si nous sommes sur l'interface d'ajout des animaux
  List<Pet> petsList = []; // liste des animaux
  String typeSelected = 'chien'; // type d'un animal par défaut

  final TextEditingController _petName = TextEditingController();
  final TextEditingController _petAge = TextEditingController();
  final TextEditingController _petBreed = TextEditingController();
  final TextEditingController _petDescription = TextEditingController();
  final TextEditingController _controllerFirstname = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPostal = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  final TextEditingController _controllerStreet = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  bool isAddressChanged = false;

  void addressChanged() { // lorsqu'on a changé d'adresse
    setState(() {
      isAddressChanged = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // Appel à Firestore pour récupérer les informations de l'objet avec l'ID spécifié
    _getObjet();
  }

  List<String> typeList = <String>[
    // List de choix pour le type d'animal
    'chien',
    'chat',
    'autre'
  ];

  void _onItemTapped(int index) { // Lorsqu'on choisit un animal
    setState(() {
      _selectedIndex = index;
    });
  }

  void changeValue(int value) { // Lorsqu'on choisit un sexe
    setState(() {
      selectedValue = value;
    });
  }

  void valueChange(String value) { // Autocompletion de l'adresse
    setState(() {
      RidesRepository().placeAutocomplete(value);
    });
  }

  void isAddSection(bool value) { // Si nous sommes dans la section d'ajout d'animaux
    setState(() {
      addPet = value;
    });
  }

  void addPetToList(Pet pet) { // Ajouter un animal de compagnie
    setState(() {
      petsList.add(pet);
    });
  }

  bool isValidName(String val) {
    if (val == null || val.isEmpty) {
      return false;
    }
    return true;
  }

  void selectPet(String ind) { // Séléctionner un animal
    setState(() {
      if (petTouched == ind) {
        petTouched = '';
      } else {
        petTouched = ind;
      }
    });
  }

  Address address =
      Address(city: '', country: '', number: '', postal: '', street: '');

  // void deletePetInList(int ind) { //Supprimer un animal
  //   setState(() {
  //     petsList.removeAt(ind);
  //     petTouched = -1;
  //   });
  // }

  Future<void> _getObjet() async {
    // Utilisez votre instance de Firestore pour récupérer l'objet avec l'ID spécifié
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(Globals().idUser)
        .get();

    if (snapshot.exists) {
      // Si l'objet existe, mettez à jour les contrôleurs de texte avec ses valeurs
      setState(() {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        _controllerFirstname.text = data['firstname'];
        _controllerLastname.text = data['lastname'];
        _controllerNumber.text = data['number'];
        _controllerEmail.text = data['email'];
        _controllerPhone.text = data['number'];
        address = Address.fromJson(data['address']);
        _controllerNumber.text = address.number;
        _controllerStreet.text = address.street;
        _controllerPostal.text = address.postal;
        _controllerCity.text = address.city;

        if (data['gender'] == 'M') {
          selectedValue = 2;
        } else {
          selectedValue = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  (!addPet)
                      ? Column(
                          children: [
                            const Text(
                              "Vos informations",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: selectedValue,
                                  fillColor: MaterialStateColor.resolveWith(
                                    (states) => Theme.of(context).primaryColor,
                                  ),
                                  onChanged: (value) {
                                    changeValue(1);
                                  },
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: const Text('Madame'),
                                    onTap: () {
                                      changeValue(1);
                                    },
                                  ),
                                ),
                                Radio(
                                  value: 2,
                                  groupValue: selectedValue,
                                  fillColor: MaterialStateColor.resolveWith(
                                    (states) => Theme.of(context).primaryColor,
                                  ),
                                  onChanged: (value) {
                                    changeValue(2);
                                  },
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: const Text('Monsieur'),
                                    onTap: () {
                                      changeValue(2);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 90,
                                    child: TextField(
                                      controller: _controllerFirstname,
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.02),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(162, 155, 254, 0.2),
                                        hintText: 'Prénom',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 90,
                                    child: TextFormField(
                                      controller: _controllerLastname,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer votre nom';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.02),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(162, 155, 254, 0.2),
                                        hintText: 'Nom',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _controllerPhone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Veuillez entrer votre numéro';
                                }
                                // Modèle de validation du numéro de téléphone (10 chiffres)
                                const phoneRegex = r'^[0-9]{10}$';
                                if (!RegExp(phoneRegex).hasMatch(value)) {
                                  return 'Numéro de téléphone invalide';
                                }
                                return null;
                              },
                              style: TextStyle(fontSize: screenHeight * 0.02),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                                hintText: 'Numéro de téléphone',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              style: TextStyle(fontSize: screenHeight * 0.02),
                              controller: _controllerEmail,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            AutoAddress(
                              controllerNumber: _controllerNumber,
                              controllerPostal: _controllerPostal,
                              valueChange: valueChange,
                              controllerStreet: _controllerStreet,
                              controllerCity: _controllerCity,
                              addressChanged: addressChanged,
                            ),
                            Row(
                              children: [
                                const Text("Choisir vos animaux de compagnie",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    isAddSection(true);
                                  },
                                  child: Chip(
                                      label: Text(
                                    '🦮 Ajouter',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: Theme.of(context).primaryColor),
                                  )),
                                )
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (addPet)
                      ? Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              style: TextStyle(fontSize: screenHeight * 0.02),
                              validator: (value) {
                                if (!isValidName(value!)) {
                                  print(!isValidName(value!));
                                  return 'Enter valid email';
                                }
                              },
                              controller: _petName,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                                hintText: 'Nom',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _petAge,
                              style: TextStyle(fontSize: screenHeight * 0.02),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                                hintText: 'Age',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
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
                              style: TextStyle(fontSize: screenHeight * 0.02),
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                                hintText: 'Race',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
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
                                        color: Theme.of(context).primaryColor,
                                        width: 2.0),
                                  ),
                                  focusColor: Colors.white,
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(162, 155, 254, 0.2),
                                ),
                                value: typeSelected,
                                // icon: Icon(getSelectionIcon(),
                                // size: 18, color: Theme.of(context).primaryColor),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                items: typeList.map<DropdownMenuItem<String>>(
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
                              style: TextStyle(fontSize: screenHeight * 0.02),
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                                hintText: 'Description',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        isAddSection(false);
                                      },
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
                                        Pet pet = Pet(
                                            name: _petName.value.text,
                                            age: int.parse(_petAge.value.text),
                                            breed: _petBreed.value.text,
                                            description:
                                                _petDescription.value.text,
                                            referenceId: '',
                                            type: typeSelected);
                                        isAddSection(false);
                                        UsersRepository()
                                            .addPet(pet, Globals().idUser);

// Navigator.pop(context, 'OK');
                                      },
                                      child: Text(
                                        'Ajouter',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90.0,
                    child: StreamBuilder<QuerySnapshot>(
                      // Liste de ses compagnons
                      stream: widget.petsCollection,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                              'Erreur lors de la récupération de vos toutous');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Recuperation en cours");
                        }
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> pets =
                                document.data()! as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                selectPet(document.id);
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
                                    (pets['type'] == 'chien')
                                        ? CircleAvatar(
                                            backgroundColor:
                                                petTouched == document.id
                                                    ? Colors.greenAccent
                                                    : const Color.fromRGBO(
                                                        113, 88, 226, 1),
                                            child: const Text(
                                              '🐶',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundColor:
                                                petTouched == document.id
                                                    ? Colors.greenAccent
                                                    : const Color.fromRGBO(
                                                        113, 88, 226, 1),
                                            child: const Text(
                                              '😸',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      pets['name'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  (petTouched != '')
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
                                  // deletePetInList(petTouched);
                                },
                                color: Colors.white, // Set the icon color
                              ),
                            )
                          ],
                        )
                      : const SizedBox(height: 10),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      if (isAddressChanged) {
                        List potentialAddress = await RidesRepository()
                            .placeAutocomplete(
                                '${_controllerNumber.value.text} ${_controllerStreet.value.text} ${_controllerCity.value.text} ${_controllerPostal.value.text}');
                        if (potentialAddress.length == 1) {
                          String firstPotentialAddress = potentialAddress.first;

                          List<String> adresseDivisee =
                              firstPotentialAddress.split(', ');

                          String rue = adresseDivisee[0];
                          String codePostalVille = adresseDivisee[1];
                          String pays = adresseDivisee[2];
                          String numeroRue = '';

                          // Trouver le premier espace dans la rue pour séparer le numéro de rue
                          int indexPremierEspace = rue.indexOf(' ');
                          if (indexPremierEspace != -1) {
                            // Extraire le numéro de rue en utilisant la sous-chaîne jusqu'à l'index du premier espace
                            numeroRue = rue.substring(0, indexPremierEspace);
                            rue = rue.substring(indexPremierEspace);
                          } else {
                            // Si aucun espace n'est trouvé, le numéro de rue est la rue complète
                            numeroRue = rue;
                          }

                          List<String> codePostalVilleDivise =
                              codePostalVille.split(' ');
                          String codePostal = codePostalVilleDivise[0];
                          String ville = codePostalVilleDivise[1];

                          Address addressTemp = Address(
                              city: ville,
                              country: pays,
                              number: numeroRue,
                              postal: codePostal,
                              street: rue);
                          userdb.User user = userdb.User(
                              email: _controllerEmail.value.text,
                              firstname: _controllerFirstname.value.text,
                              lastname: _controllerLastname.value.text,
                              gender: selectedValue == 2 ? 'M' : 'F',
                              address: addressTemp,
                              number: _controllerPhone.value.text,
                              password: '');
                          UsersRepository().updateUser(user);
                        }
                      } else {
                        userdb.User user = userdb.User(
                            email: _controllerEmail.value.text,
                            firstname: _controllerFirstname.value.text,
                            lastname: _controllerLastname.value.text,
                            gender: selectedValue == 2 ? 'M' : 'F',
                            address: address,
                            number: _controllerPhone.value.text,
                            password: '');
                        UsersRepository().updateUser(user);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Se déconnecter',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 14),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        // Bottom sheet navigation
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
