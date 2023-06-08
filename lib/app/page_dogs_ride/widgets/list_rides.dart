import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/models/rides.dart';
import 'package:i2_i3_g9/app/models/users.dart';
import 'package:i2_i3_g9/app/repository/RidesRepository.dart';
import 'package:i2_i3_g9/app/repository/usersRepository.dart';
import 'package:i2_i3_g9/app/page_dogs_ride/widgets/view_more.dart';
import '../../utils/globals.dart';

class ListRide extends StatelessWidget {
  final Stream<QuerySnapshot> ridesCollection;
  ListRide(
      {Key? key,
      required this.ridesCollection,})
      : super(key: key);


  String cityOfAddress(Map<String, dynamic> ride) {
    Rides rideTemp = Rides.fromJson(ride);
    int addressLength = rideTemp.address.split(' ').length;
    return rideTemp.address.split(' ')[addressLength - 2];
  }

  String hourOfRide(Map<String, dynamic> ride) {
    Rides rideTemp = Rides.fromJson(ride);
    final formatter = DateFormat('HH:mm', 'fr_FR');
    var time = DateTime.fromMicrosecondsSinceEpoch(
        rideTemp.time.microsecondsSinceEpoch);
    return formatter.format(time);
  }

  String dayOfRide(Map<String, dynamic> ride) {
    Rides rideTemp = Rides.fromJson(ride);
    final formatter = DateFormat('MMM dd', 'fr_FR');
    var date = DateTime.fromMicrosecondsSinceEpoch(
        rideTemp.time.microsecondsSinceEpoch);
    return formatter.format(date);
  }

  Future<Users?> userNames(Map<String, dynamic> ride) async {
    Rides rideTemp = Rides.fromJson(ride);
    Users? futureUser = await UsersRepository().getUserById(rideTemp.creator);
    return futureUser;
  }

  Future<QuerySnapshot<Object?>> getPetsOfRide(Map<String, dynamic> ride) {
    Rides rideTemp = Rides.fromJson(ride);
    return RidesRepository().getPetsOfRide(rideTemp);
  }

  final Stream<QuerySnapshot> petsCollection =
      UsersRepository().getPetsOfUserStream(Globals().idUser);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ridesCollection,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Erreur lors de la récupération des balades');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Recuperation en cours");
        }
        return ListView.builder(
          padding: const EdgeInsets.only(left: 1, right: 1, top: 5),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            final DocumentSnapshot document = snapshot.data!.docs[index];
            final Map<String, dynamic> rides =
                document.data() as Map<String, dynamic>;
            return SizedBox(
              height: 100,
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0)),
                          ),
                          builder: (BuildContext context) {
                            return SizedBox(
                              child: ViewMore(
                                ride: rides,
                                dayOfRide: dayOfRide,
                                users: userNames(rides),
                                getPetsOfRide: getPetsOfRide,
                                hourOfRide: hourOfRide,
                                documentId: document.id,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        color: Colors.white10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cityOfAddress(rides),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dayOfRide(rides)} · ${hourOfRide(rides)}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${rides['pets'].length} Compagnon(s) 🐶 😸',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 115),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.forum_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ), // Icon on the left
                                const SizedBox(width: 3),
                                Text(
                                  'Messages',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
