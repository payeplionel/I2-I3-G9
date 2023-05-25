import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/repository/RidesRepository.dart';
import 'package:i2_i3_g9/app/utils/globals.dart';
import 'package:i2_i3_g9/app/widgets/filter_trips.dart';
import 'package:i2_i3_g9/app/widgets/list_rides.dart';
import 'package:i2_i3_g9/app/widgets/map_overview.dart';
import 'package:i2_i3_g9/app/widgets/nav-bar.dart';

class DogsRide extends StatefulWidget {
  DogsRide({Key? key}) : super(key: key);

  @override
  State<DogsRide> createState() => _DogsRideState();

  final Stream<QuerySnapshot> ridesCollection =
      RidesRepository().getRidesForUser(Globals().idUser);
}

class _DogsRideState extends State<DogsRide> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController
      _increaseController; // Controlleur pour la liste des balades
  late AnimationController _mapController; // Controlleur pour la Map
  late Animation<double>
      _increaseAnimation; // Gestion de l'agrandissement de l'écran pour les balades
  late Animation<double>
      _mapAnimation; // Gestion de l'agrandissement pour la Map
  double sizeContainer = 0.50; // Taille de l'écran au démarrage
  bool isMap = false; // Vérifie si la Map est agrandi
  bool isJourneys = false; // Vérifie si la liste des balades est agrandi
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late String _description = '';
  void _updateDescription(String text) {
    setState(() {
      _description = text;
    });
  }

  @override
  void initState() {
    super.initState();

    _increaseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _mapController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _increaseAnimation =
        CurvedAnimation(parent: _increaseController, curve: Curves.easeInOut);
    _mapAnimation =
        CurvedAnimation(parent: _mapController, curve: Curves.easeInOut);
    _increaseAnimation.addListener(() {
      setState(() {
        // debugPrint("valeur de l'anim ${_increaseAnimation.value * 0.25}");
        if (sizeContainer < 0.75 && sizeContainer >= 0.50) {
          // Si l'écran est à 50% il passe à 75% pour les balades
          sizeContainer = 0.50 + (_increaseAnimation.value * 0.25);
        } else if (sizeContainer < 0.50) {
          // Si l'écran est à 25% il passe à 75% pour les balades
          sizeContainer = 0.25 + (_increaseAnimation.value * 0.75);
        }
      });
    });
    _mapAnimation.addListener(() {
      setState(() {
        if (sizeContainer > 0.25 && sizeContainer <= 0.50) {
          // Si l'écran est à 50% il passe à 75% pour la map
          sizeContainer = 0.50 - (_mapAnimation.value * 0.25);
        } else if (sizeContainer > 0.50) {
          // Si l'écran est à 25% il passe à 75% pour la map
          sizeContainer = 0.75 - (_mapAnimation.value * 0.75);
        }
      });
    });
  }

  @override
  void dispose() {
    _increaseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _startAnimationIncrease() {
    // Gestion de l'animation d'agrandissement pour des balades
    _increaseController.reset();
    _increaseController.forward();
    isMap = false; // Map ne s'est pas agrandi
    isJourneys = true; // La liste des baldes s'est agrandi
  }

  void _startAnimationMap() {
    // Gestion de l'animation d'agrandissement pour la map
    _mapController.reset();
    _mapController.forward();
    isMap = true; // Map s'est agrandi
    isJourneys = false; // La liste des baldes ne s'est pas agrandi
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Expanded(child: MapOverview()),
          Expanded(
              child: GestureDetector(
            onVerticalDragUpdate: isMap
                ? null
                : (DragUpdateDetails details) {
                    _startAnimationMap(); // Lancer l'animation d'agrandissement
                  },
            child: SizedBox(
              height: screenHeight * sizeContainer,
              child: MapOverview(), // Affichage de la Google Map
            ),
          )),
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (isJourneys == false) {
                _startAnimationIncrease();
              }
              return true;
            },
            child: Container(
                height: screenHeight * sizeContainer,
                margin: const EdgeInsets.all(1.0),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                  minHeight: MediaQuery.of(context).size.height * 0.25,
                ),
                child: SizedBox(
                  height: 25,
                  child: ListRide(
                      ridesCollection: widget.ridesCollection),
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            builder: (BuildContext context) {
              return const FilterTrips();
            },
          );
        },
        backgroundColor: const Color.fromRGBO(48, 51, 107, 0.8),
        mini: true,
        child: const ImageIcon(
          AssetImage('assets/images/filter.png'),
          size: 18,
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