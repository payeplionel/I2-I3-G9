import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/models/users.dart';

import '../repository/usersRepository.dart';

class ListPets extends StatelessWidget {
  ListPets(
      {Key? key,
        required this.updatePetsSelected,
        required this.searchInPetsSelected, required this.petsCollection})
      : super(key: key);
  Function updatePetsSelected;
  Stream<QuerySnapshot> petsCollection;
  final Function searchInPetsSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Qui fera la balade ? Ajouter-le",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: Color.fromRGBO(44, 58, 71, 1))),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 90.0,
          child: StreamBuilder<QuerySnapshot>( // Liste de ses compagnons
            stream: petsCollection,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text(
                    'Erreur lors de la récupération de vos toutous');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Recuperation en cours");
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> pets =
                  document.data()! as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      updatePetsSelected(document.id);
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
                          (pets['type'] == 'chien')
                              ? CircleAvatar(
                            backgroundColor: searchInPetsSelected(document.id) != -1
                                ? Colors.greenAccent
                                : const Color.fromRGBO(113, 88, 226, 1),
                            child: const Text(
                              '🐶',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                              : CircleAvatar(
                            backgroundColor: searchInPetsSelected(document.id) !=-1
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
                            pets['name'],
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        )
      ],
    );
  }
}
