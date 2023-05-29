import 'package:flutter/material.dart';

class FilterTrips extends StatefulWidget {
  const FilterTrips({super.key});

  @override
  State<FilterTrips> createState() => _FilterTripsState();
}

enum SingingCharacter { heure, proche, distance }

class _FilterTripsState extends State<FilterTrips> {
  SingingCharacter? _character = SingingCharacter.heure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Trier par ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Expanded(child: Column(
            children: [
              RadioListTile<SingingCharacter>(
                title: const Text('Départ le plus tôt'), // Filter par heure de debut
                secondary: const Icon(Icons.schedule_rounded),
                value: SingingCharacter.heure,
                groupValue: _character,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile<SingingCharacter>(
                title: const Text('Proche de votre localisation'), // Filter par le plus proche de localisation
                secondary: const Icon(Icons.near_me),
                value: SingingCharacter.proche,
                groupValue: _character,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile<SingingCharacter>(
                title: const Text('Durée la plus courte'), // Filtrer par la durée la plus courte
                secondary: const Icon(Icons.timelapse_rounded),
                value: SingingCharacter.distance,
                groupValue: _character,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Filtrer',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}