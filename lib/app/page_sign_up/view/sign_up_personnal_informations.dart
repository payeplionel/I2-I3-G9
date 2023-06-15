import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/autocomplete_address.dart';

class PersonnalInformation extends StatelessWidget {
  PersonnalInformation({
    Key? key,
    required this.selectedValue,
    required this.changeValue,
    required this.controllerPostal,
    required this.valueChange,
    required this.controllerFirstname,
    required this.navigationSign,
    required this.controllerLastname,
    required this.controllerPhone,
    required this.controllerStreet,
    required this.controllerCity,
    required this.addressChanged,
    required this.controllerNumber,
    required this.pickImageFromCamera,
    required this.pickImageFromGallery,
    required this.imageFile,
    required this.showImage,
  }) : super(key: key);
  int selectedValue;
  Function changeValue;
  Function valueChange;
  Function navigationSign;
  TextEditingController controllerPostal;
  TextEditingController controllerFirstname;
  TextEditingController controllerLastname;
  TextEditingController controllerPhone;
  TextEditingController controllerCity;
  TextEditingController controllerStreet;
  TextEditingController controllerNumber;
  XFile? imageFile;
  Function addressChanged;
  Function pickImageFromCamera;
  Function pickImageFromGallery;
  Function showImage;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    void personnalValidation() {
      String message = '';
      if (controllerFirstname.value.text.isEmpty) {
        message += 'prénom';
      }
      if (controllerLastname.value.text.isEmpty) {
        message += ' nom';
      }
      if (controllerPhone.value.text.isEmpty) {
        message += ' téléphone';
      }
      if (controllerCity.value.text.isEmpty) {
        message += ' Ville';
      }
      if (controllerPostal.value.text.isEmpty) {
        message += ' code postal';
      }
      if (controllerNumber.value.text.isEmpty) {
        message += ' numéro de rue';
      }
      if (controllerStreet.value.text.isEmpty) {
        message += ' adresse';
      }
      if (message.isNotEmpty) {
        final snackBar = SnackBar(
          content: Text('$message invalide(s)'),
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            label: 'Fermer',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        navigationSign(2);
      }
    }

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Veuillez entrer vos informations personnelles",
            style: TextStyle(
              fontSize: 14,
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
                  child: TextFormField(
                    controller: controllerFirstname,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre prénom';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: screenHeight * 0.02),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(162, 155, 254, 0.2),
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
                    controller: controllerLastname,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: screenHeight * 0.02),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(162, 155, 254, 0.2),
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
            controller: controllerPhone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer votre numéro';
              }
              // Modèle de validation du numéro de téléphone (10 chiffres)
              final phoneRegex = r'^[0-9]{10}$';
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
          AutoAddress(
            controllerNumber: controllerNumber,
            controllerPostal: controllerPostal,
            valueChange: valueChange,
            controllerCity: controllerCity,
            controllerStreet: controllerStreet,
            addressChanged: addressChanged,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    imageFile = await pickImageFromCamera();
                    showImage(imageFile);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor), // Couleur du bouton
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/camera.png', // Chemin vers votre image locale
                        width: 24, // Largeur de l'image
                        height: 24, // Hauteur de l'image
                      ),
                      SizedBox(width: 8.0),
                      const Expanded(child: Text('Prendre une photo')),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    imageFile = await pickImageFromGallery();
                    showImage(imageFile);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor), // Couleur du bouton
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/picture.png', // Chemin vers votre image locale
                        width: 24, // Largeur de l'image
                        height: 24, // Hauteur de l'image
                      ),
                      const SizedBox(width: 8.0),
                      const Expanded(child: Text('Choisir une photo')),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // Affichage de l'image dans un Container

          // Affiche l'image
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Forme du conteneur (cercle dans ce cas)
            ),
            child: ClipOval(
              child: imageFile != null
                  ? Image.file(
                      File(imageFile!.path),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/picture.png', // Chemin vers votre image statique
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  personnalValidation();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Continuer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.02,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
