import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/models/user.dart';
import 'package:i2_i3_g9/app/page_sign_up/view/sign_pets.dart';
import 'package:i2_i3_g9/app/page_sign_up/view/sign_up_auth.dart';
import 'package:i2_i3_g9/app/page_sign_up/view/sign_up_personnal_informations.dart';
import 'package:i2_i3_g9/app/page_login/view/login.dart';
import 'package:i2_i3_g9/app/repository/usersRepository.dart';

import '../../models/address.dart';
import '../../models/pet.dart';
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
  final TextEditingController _petName = TextEditingController();
  final TextEditingController _petAge = TextEditingController();
  final TextEditingController _petBreed = TextEditingController();
  final TextEditingController _petDescription = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerFirstname = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordVerif =
      TextEditingController();

  int selectedValue = 1;
  bool addPet = false;
  List<Pet> petsList = [];
  List<String> typeList = <String>[
    // List de choix pour le type d'animal
    'chien',
    'chat',
    'autre'
  ];
  String typeSelected = 'chien';
  int petTouched = -1;
  int navigate = 1;

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
    if (response != null) {}
  }

  void valueChange(String value) {
    setState(() {
      placeAutocomplete(value);
    });
  }

  void changeValue(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  void navigationSign(int value) {
    setState(() {
      navigate = value;
    });
  }

  void isAddSection(bool value){
    setState(() {
      addPet = value;
    });
  }

  void addPetToList(Pet pet){
    setState(() {
      petsList.add(pet);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
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
                (navigate == 1)
                    ? PersonnalInformation(
                  selectedValue: selectedValue,
                  changeValue: changeValue,
                  valueChange: valueChange,
                  controllerAddress: _controllerAddress,
                  navigationSign: navigationSign,
                  controllerFirstname: _controllerFirstname,
                  controllerLastname: _controllerLastname,
                  controllerNumber: _controllerNumber,
                )
                    : const SizedBox.shrink(),
                (navigate == 2)
                    ? SignAuth(
                  navigationSign: navigationSign,
                  controllerEmail: _controllerEmail,
                  controllerPassword: _controllerPassword,
                  controllerPasswordVerif: _controllerPasswordVerif,
                )
                    : const SizedBox.shrink(),
                (navigate == 3)
                    ? Column(
                  children: [
                    SignPets(
                        isValidName: isValidName,
                        petAge: _petAge,
                        petBreed: _petBreed,
                        petDescription: _petDescription,
                        petName: _petName,
                        typeSelected: typeSelected,
                        typeList: typeList,
                        petsList: petsList,
                        selectPet: selectPet,
                        petTouched: petTouched,
                        deletePetInList: deletePetInList,
                        addPet: addPet,
                        isAddSection: isAddSection,
                        addPetToList: addPetToList,
                    ),

                    (!addPet)
                    ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // placeAutocomplete("3 avenue ernest ruben");
                                  navigationSign(2);
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'Retour',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: screenHeight * 0.02,
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
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // placeAutocomplete("3 avenue ernest ruben");
                                  debugPrint('${_controllerLastname.value.text} '
                                      ' ${_controllerFirstname.value.text}'
                                      ' ${_controllerEmail.value.text}'
                                      ' ${_controllerPassword.value.text}'
                                      ' ${_controllerNumber.value.text}');
                                  User user = User(
                                      email: _controllerEmail.value.text,
                                      firstname: _controllerFirstname.value.text,
                                      lastname: _controllerLastname.value.text,
                                      gender: selectedValue == 1 ? 'F' : 'M',
                                      password: _controllerPassword.value.text,
                                      address:  Address(
                                          city: 'Brive',
                                          country: 'France',
                                          number: '3',
                                          postal: '19360',
                                          street: 'Av de l\'industrie'
                                      ),
                                  );
                                  UsersRepository().addUser(user, petsList);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                  Theme.of(context).primaryColor,
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
                      ],
                    )
                    : const SizedBox.shrink(),

                    const SizedBox(height: 10),
                  ],
                )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
