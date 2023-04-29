import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/widgets/list_rides.dart';
import 'package:i2_i3_g9/app/widgets/map_overview.dart';
import 'package:i2_i3_g9/app/models/ride.dart';

class DogsRide extends StatefulWidget {
  const DogsRide({Key? key}) : super(key: key);

  @override
  State<DogsRide> createState() => _DogsRideState();
}

class _DogsRideState extends State<DogsRide> with TickerProviderStateMixin {
  final List<Ride> _rides = <Ride>[];
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
    // Valeur temp
    var ride = new Ride('LP', 'Limoges', 'Bordeaux');
    var ride2 = new Ride('TD', 'Limoges', 'Brive');
    _rides.add(ride);
    _rides.add(ride2);

    return Scaffold(
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
              child: Container(
                height: screenHeight * sizeContainer,
                child: MapOverview(), // Affichage de la Google Map
              ),
            )),
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification){
                if(isJourneys == false){
                  _startAnimationIncrease();
                }
                return true;
              },
              child:  Container(
                  height: screenHeight * sizeContainer,
                  margin: const EdgeInsets.all(1.0),
                  child: SizedBox(
                    height: 25,
                    child: ListRide(),
                    // child: ListRide(
                    //     image: "I",
                    //     depart: "Limoges",
                    //     destination: "Brive",
                    //     onPressedMessage: () {},
                    //     onPressedDone: () {}),
                  )
              ),
            ),
          ],
    ));
  }
}

// Container(
//   height: screenHeight * sizeContainer,
//   child: ListView.separated(
//     padding: const EdgeInsets.all(8),
//     itemCount: _rides.length,
//     itemBuilder: (BuildContext context, int index){
//       return ListRide(image: _rides[index].image, depart: _rides[index].depart,
//           destination: _rides[index].destination,
//           onPressedMessage: (){},
//           onPressedDone: (){});
//     },
//     separatorBuilder: (BuildContext context, int index) => const Divider(),
//   ),
// ),
