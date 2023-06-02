import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:i2_i3_g9/app/models/address.dart';
import 'package:i2_i3_g9/app/models/rides.dart';
import 'package:i2_i3_g9/app/repository/RidesRepository.dart';
import 'package:i2_i3_g9/app/repository/usersRepository.dart';
import 'package:i2_i3_g9/app/utils/globals.dart';
import 'package:i2_i3_g9/app/page_create_trip/widgets/date_starting.dart';
import 'package:i2_i3_g9/app/page_create_trip/widgets/list_pets.dart';
import 'package:i2_i3_g9/app/page_create_trip/widgets/select_starting.dart';
import '../../page_navbar/view/nav-bar.dart';

class CreateTrip extends StatefulWidget {
  CreateTrip({Key? key}) : super(key: key);

  // Récupération de la liste des animaux domestiques d'un utilisateur
  final Stream<QuerySnapshot> petsCollection =
  UsersRepository().getPetsOfUserStream(Globals().idUser);

  @override
  State<CreateTrip> createState() => _CreateTrip();
}

class _CreateTrip extends State<CreateTrip> {
  final ScrollController scrollController = ScrollController();
  int _selectedIndex = 1;
  List<String> petsSelected = []; // Liste des animaux qui vont faire la balade
  String dropdownValue = 'Mon domicile';
  String manualAddress = '';
  DateTime date =
  DateTime.now().add(const Duration(hours: 1)); // Ajouter une date minimum
  DateTime time =
  DateTime.now().add(const Duration(hours: 1)); // Ajouter une heure minimum
  String warningText = '';
  String? _currentAddress;
  Position? _currentPosition;

  void _onItemTapped(int index) {
    // Action lorsqu'on clique sur un animal de compagnie dans la liste
    setState(() {
      _selectedIndex = index;
    });
  }

  int searchInPetsSelected(String petId) {
    // Recherche si un animal de compagnie est déjà dans la balade ou noù
    return petsSelected.indexWhere((element) => element == petId);
  }

  void updatePetsSelected(String petId) {
    // Ajout ou retrait d'un animal de compagnie dans la balade
    setState(() {
      int index = searchInPetsSelected(petId);
      if (index == -1) {
        petsSelected.add(petId);
      } else {
        petsSelected.removeAt(index);
      }
    });
  }

  Future<void> updateDeparturePoint(String departure) async {
    // Choix du point de départ
    if (departure == 'Ma position actuelle') {
      await _getCurrentPosition();
      _getAddressFromLatLng(_currentPosition!);
    }
    setState(() {
      dropdownValue = departure;
    });
  }

  // Récupérer l'adresse sous le format humain
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.postalCode},${place.locality}, ${place.country}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void updateDate(DateTime dateTime) {
    // Choix de l'heure
    setState(() => {date = dateTime});
  }

  void updateTime(DateTime dateTime) {
    // Choix de la data
    setState(() => {time = dateTime});
  }

  void createRide() async {
    Address? address = await UsersRepository()
        .getAddressById(Globals().idUser); // Récupération de l'utilisateur
    if (address != null && petsSelected.isNotEmpty) {
      // Vérifier que l'adresse et qu'un animal a été choisi
      String isNotAvailable = await RidesRepository()
          .isAvailableOrNot(time, Globals().idUser, petsSelected);
      if (isNotAvailable.isNotEmpty) {
        // Vérifier que les animaux sont disponibles, ne sont pas déjà dans une balade dans un intervalle de 6 heures
        warningText =
        '$isNotAvailable déjà présent dans une autre balade, veuillez séparer les balades d\'au moins 3 heures avec cette nouvelle balade 😿';
        final snackBar = SnackBar(
          content: Text(warningText),
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            label: 'Voir',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        if(dropdownValue == 'Ma position actuelle'){
          Rides ride = Rides(
            // Ajout d'un nouveau trajet
              address: _currentAddress.toString(),
              code: '',
              partner: '',
              pets: petsSelected,
              creator: Globals().idUser,
              date: Timestamp.fromDate(date),
              time: Timestamp.fromDate(time),
              status: 'available');
          RidesRepository().addRide(ride);
        }else {
          Rides ride = Rides(
            // Ajout d'un nouveau trajet
              address: address.toString(),
              code: '',
              partner: '',
              pets: petsSelected,
              creator: Globals().idUser,
              date: Timestamp.fromDate(date),
              time: Timestamp.fromDate(time),
              status: 'available');
          RidesRepository().addRide(ride);
        }
      }
    } else {
      if (petsSelected.isEmpty) {
        warningText = 'Sélectionner au moins un animal de compagnie';
      }
      final snackBar = SnackBar(
        content: Text(warningText),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
          label: 'Fermer',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Ajouter une balade',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                              color: Color.fromRGBO(44, 58, 71, 1))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SelectStarting(
                          dropdownValue: dropdownValue,
                          updateDeparturePoint: updateDeparturePoint,
                          currentAddress: _currentAddress,
                          manualAddress: manualAddress,
                        ),
                        DateStarting(
                          // Widget pour le choix du point de départ
                          date: date,
                          time: time,
                          updateDate: updateDate,
                          updateTime: updateTime,
                          context: this.context,
                        ),
                        ListPets(
                          // Widget pour l'affichage des animaux de compagnies
                          updatePetsSelected: updatePetsSelected,
                          searchInPetsSelected: searchInPetsSelected,
                          petsCollection: widget.petsCollection,
                        )
                      ],
                    ),
                  )
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10.0),
                    child: OutlinedButton(
                      onPressed: () {
                        createRide();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Créer la balade',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
      bottomNavigationBar: NavBar(
        // Bottom sheet navigation
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}