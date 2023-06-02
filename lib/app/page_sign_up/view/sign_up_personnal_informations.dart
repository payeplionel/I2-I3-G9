import 'package:flutter/material.dart';
import '../widgets/autocomplete_address.dart';

class PersonnalInformation extends StatelessWidget {
  PersonnalInformation({
    Key? key,
    required this.selectedValue,
    required this.changeValue,
    required this.controllerAddress,
    required this.valueChange,
    required this.controllerFirstname,
    required this.navigationSign,
    required this.controllerLastname,
    required this.controllerNumber,
  }) : super(key: key);
  int selectedValue;
  Function changeValue;
  Function valueChange;
  Function navigationSign;
  TextEditingController controllerAddress;
  TextEditingController controllerFirstname;
  TextEditingController controllerLastname;
  TextEditingController controllerNumber;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
            controller: controllerNumber,
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
            controllerAddress: controllerAddress,
            valueChange: valueChange,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  // if (Form.of(context).validate()) {
                  //   navigationSign(2);
                  // }
                  navigationSign(2);
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
