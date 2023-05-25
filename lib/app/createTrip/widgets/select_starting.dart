import 'package:flutter/material.dart';

class SelectStarting extends StatelessWidget {
  SelectStarting(
      {super.key,
      required this.dropdownValue,
      required this.updateDeparturePoint, required this.manualAddress,
      required this.currentAddress});
  String dropdownValue; // point de départ
  String manualAddress; // Adresse saisi par l'utilisateur
  String? currentAddress;
  Function updateDeparturePoint; // Changement du point de départ

  List<String> list = <String>[
    // List de choix pour le point de départ
    'Mon domicile',
    'Ma position actuelle',
    'Choisir une adresse'
  ];

  IconData getSelectionIcon() {
    // Icons pour le choix des points de départ
    switch (dropdownValue) {
      case 'Mon domicile':
        return Icons.house_outlined;
      case 'Ma position actuelle':
        return Icons.location_on_outlined;
      case 'Choisir une adresse':
        return Icons.mode_of_travel_outlined;
      default:
        return Icons.house_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Départ ",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  color: Color.fromRGBO(44, 58, 71, 1)),
            ),
            SizedBox(
              width: 200,
              child: DropdownButtonFormField(
                  // Sélection de son lieu de départ
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    focusColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: dropdownValue,
                  icon: Icon(getSelectionIcon(),
                      size: 18, color: Theme.of(context).primaryColor),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    updateDeparturePoint(value!);
                  }),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              if (dropdownValue == 'Ma position actuelle')
                TextField(
                  // Entrer la date par autocompletion avec google
                  enabled: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: '$currentAddress',
                  ),
                ),
              if (dropdownValue == 'Choisir une adresse')
                TextField(
                  // Entrer la date par autocompletion avec google
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Entrer l\'adresse',
                  ),
                ),
            ],
          ),
        )

      ],
    );
  }
}
