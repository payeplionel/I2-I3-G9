import 'package:flutter/material.dart';

import '../../models/pet.dart';

class SignPets extends StatelessWidget {
  SignPets(
      {Key? key,
      required this.isValidName,
      required this.petAge,
      required this.petBreed,
      required this.petDescription,
      required this.petName,
      required this.typeSelected,
      required this.typeList,
      required this.petsList,
      required this.selectPet,
      required this.petTouched,
      required this.deletePetInList,
      required this.addPet,
      required this.isAddSection, required this.addPetToList})
      : super(key: key);

  final _formKeyPet = GlobalKey<FormState>();
  Function isValidName;
  TextEditingController petName;
  TextEditingController petAge;
  TextEditingController petBreed;
  TextEditingController petDescription;
  String typeSelected;
  List<String> typeList;
  List<Pet> petsList;
  Function selectPet;
  int petTouched;
  Function deletePetInList;
  bool addPet;
  Function isAddSection;
  Function addPetToList;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          children: [
            const Text("Choisir vos animaux de compagnie",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                )),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: (){
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
                    controller: petName,
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
                    controller: petAge,
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
                    controller: petBreed,
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
                        fillColor: const Color.fromRGBO(162, 155, 254, 0.2),
                      ),
                      value: typeSelected,
                      // icon: Icon(getSelectionIcon(),
                      //     size: 18, color: Theme.of(context).primaryColor),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      items: typeList
                          .map<DropdownMenuItem<String>>((String value) {
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
                    controller: petDescription,
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
                                  name: petName.value.text,
                                  age: int.parse(petAge.value.text),
                                  breed: petBreed.value.text,
                                  description: petDescription.value.text,
                                  referenceId: '',
                                  type: typeSelected);
                              isAddSection(false);
                              addPetToList(pet);

                              // Navigator.pop(context, 'OK');
                            },
                            child: Text(
                              'Créer',
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
                                    : const Color.fromRGBO(113, 88, 226, 1),
                                child: const Text(
                                  '🐶',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: petTouched == index
                                    ? Colors.greenAccent
                                    : const Color.fromRGBO(113, 88, 226, 1),
                                child: const Text(
                                  '😸',
                                  style: TextStyle(color: Colors.white),
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
                      color: Color.fromRGBO(
                          162, 155, 254, 1), // Set the background color here
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
                      color: Color.fromRGBO(
                          255, 118, 117, 0.8), // Set the background color here
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
      ],
    );
  }
}
