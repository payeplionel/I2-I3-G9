import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/repository/RidesRepository.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../models/user.dart';
import '../../utils/globals.dart';

class ViewMore extends StatefulWidget {
  ViewMore(
      {Key? key,
      required this.ride,
      required this.hourOfRide,
      required this.dayOfRide,
      required this.users,
      required this.getPetsOfRide,
      required this.documentId})
      : super(key: key);
  Map<String, dynamic> ride;
  String documentId;
  Function dayOfRide;
  Function hourOfRide;
  Future<User?> users;
  Function getPetsOfRide;

  @override
  State<ViewMore> createState() => _ViewMore();
}

class _ViewMore extends State<ViewMore> {
  String description = '';
  void closeBottomSheet() {
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(left: 30.0, top: 2.0, right: 10.0),
            height: 60,
            child: Row(
              // Nom et Prenom de la personne qui propose la balade
              children: [
                FutureBuilder<User?>(
                  future: widget.users,
                  builder:
                      (BuildContext context, AsyncSnapshot<User?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer(
                        duration: const Duration(milliseconds: 1500),
                        direction: const ShimmerDirection.fromLeftToRight(),
                        child: Container(
                          width: 50.0,
                          height: 10.0,
                          color: Colors.grey, // Set a background color for the skeleton
                        ),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Text(
                            'Une erreur s\'est produite : ${snapshot.error}');
                      } else {
                        final User? user = snapshot.data;
                        return Row(
                          children: [
                            Text(
                              '${user?.firstname}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${user?.lastname}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        );
                      }
                    }
                  },
                )
              ],
            )),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: Column(
              children: [
                Row(
                  // Date et heure de la balade
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Date :",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Chip(
                        backgroundColor: const Color.fromRGBO(48, 51, 107, 0.1),
                        avatar: const Icon(
                          Icons.calendar_month_sharp,
                          color: Color.fromRGBO(48, 51, 107, 1),
                          size: 20,
                        ),
                        label: Text(
                          '${widget.dayOfRide(widget.ride)} · ${widget.hourOfRide(widget.ride)}',
                          style: const TextStyle(
                              color: Color.fromRGBO(48, 51, 107, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 2.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Compagnon(s) de balade : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 90.0,
                  child: FutureBuilder<QuerySnapshot>(
                    future: widget.getPetsOfRide(widget.ride),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer(
                          duration: const Duration(milliseconds: 1500),
                          direction: const ShimmerDirection.fromLeftToRight(),
                          child: Container(
                            width: 100.0,
                            height: 10.0,
                            color: Colors.grey, // Set a background color for the skeleton
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Erreur: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> pets =
                                document.data()! as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  description = pets['description'];
                                });
                              },
                              child: (pets['type'] == 'chien')
                                  ? Row(
                                      children: [
                                        Chip(
                                          backgroundColor: const Color.fromRGBO(
                                              48, 51, 107, 0.1),
                                          avatar: const Text("🐶"),
                                          label: Text(
                                            '${pets['name']}',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    48, 51, 107, 1)),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0)
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Chip(
                                          backgroundColor: const Color.fromRGBO(
                                              48, 51, 107, 0.1),
                                          avatar: const Text("😸"),
                                          label: Text(
                                            '${pets['name']}',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    48, 51, 107, 1)),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        )
                                      ],
                                    ),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('Aucun résultat trouvé.');
                      }
                    },
                  ),
                ),
                const Divider(
                  height: 2.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Align(
                  // Description de la balade
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Adresse :",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: '${widget.ride['address']}',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                          wordSpacing: 2.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                (description.isNotEmpty)
                    ? SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            const Align(
                              // Description de la balade
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Description :",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Align(
                              alignment: Alignment.topLeft,
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  text: '${description}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                      wordSpacing: 2.0),
                                ),
                              ),
                            ))
                          ],
                        ),
                      )
                    : const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.ride['parter']=Globals().idUser;
                    Map<String, dynamic> newRide = {
                      'address': widget.ride['address'],
                      'code': widget.ride['code'],
                      'partner': Globals().idUser,
                      'pets': widget.ride['pets'],
                      'status': 'in progress',
                      'creator': widget.ride['creator'],
                      'date': widget.ride['date'],
                      'time': widget.ride['time'],
                    };
                    RidesRepository().updateRide(widget.documentId, newRide);
                    closeBottomSheet();
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Accepter',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            )),
          ],
        )
      ],
    );
  }
}
