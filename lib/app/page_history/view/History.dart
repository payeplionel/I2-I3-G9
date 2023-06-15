import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:i2_i3_g9/app/models/user.dart' as userdb;
import 'package:i2_i3_g9/app/repository/usersRepository.dart';
import '../../page_navbar/view/nav-bar.dart';
import '../../repository/RidesRepository.dart';
import '../../utils/globals.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();

  final Stream<QuerySnapshot> ridesDidCollection =
      RidesRepository().getRidesDidByUser(Globals().idUser);

  final Stream<QuerySnapshot> ridesInProgressCollection =
      RidesRepository().getProgressRidesForUser(Globals().idUser);

  final Stream<QuerySnapshot> ridesPastCollection =
  RidesRepository().getRidesDidByUser(Globals().idUser);
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 2;
  bool _keyboardVisible = false;
  void _onItemTapped(int index) {
    // Action lorsqu'on clique sur un animal de compagnie dans la liste
    setState(() {
      _selectedIndex = index;
    });
  }

  int isUpdating = -1;

  final TextEditingController _textDefaultController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Theme.of(context)
                .primaryColor, // Couleur de l'arrière-plan du TabBar
            child: const Padding(
                padding: EdgeInsets.only(top: 30),
                child: TabBar(
                  tabs: [
                    Tab(text: 'En cours'),
                    Tab(text: 'A Valider'),
                    Tab(text: 'Effectués'),
                  ],
                )),
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: widget.ridesInProgressCollection,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Erreur lors de la récupération des balades');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Recuperation en cours");
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document =
                        snapshot.data!.docs[index];
                    final Map<String, dynamic> rides =
                        document.data() as Map<String, dynamic>;
                    Future<userdb.User?> partner =
                        UsersRepository().getUserById(rides['partner']);
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                            border: const GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                                Colors.blueAccent,
                                Colors.deepPurpleAccent,
                                Colors.deepPurple
                              ]),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                color: const Color.fromRGBO(220, 221, 225, 0.5),
                                child: Center(
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Code de validation',
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${rides['code']}',
                                        style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<userdb.User?>(
                                    future: UsersRepository()
                                        .getUserById(rides['partner']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<userdb.User?> snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Une erreur s\'est produite'); // Afficher un message d'erreur
                                      } else if (snapshot.hasData) {
                                        userdb.User? partner = snapshot.data;
                                        return Text(
                                            'Accepté par : ${partner?.firstname} ${partner?.lastname}'); // Afficher le nom du partenaire s'il existe, sinon afficher "N/A"
                                      } else {
                                        return const Text(
                                            'Aucune donnée'); // Afficher un message si aucune donnée n'est disponible
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Lieux : ${rides['address']}"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: widget.ridesDidCollection,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Erreur lors de la récupération des balades');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Recuperation en cours");
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document =
                        snapshot.data!.docs[index];
                    final Map<String, dynamic> rides =
                        document.data() as Map<String, dynamic>;
                    Future<userdb.User?> partner =
                        UsersRepository().getUserById(rides['partner']);
                    if (_keyboardVisible) {
                      if (index == isUpdating) {
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Container(
                            width: 300,
                            height: 200,
                            decoration: BoxDecoration(
                                border: const GradientBoxBorder(
                                  gradient: LinearGradient(colors: [
                                    Colors.blueAccent,
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple
                                  ]),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    color: const Color.fromRGBO(
                                        220, 221, 225, 0.5),
                                    child: Center(
                                      child: TextFormField(
                                        controller: _textDefaultController,
                                        focusNode: _focusNode,
                                        keyboardType: TextInputType.number,
                                        onFieldSubmitted: (String value) async {
                                          bool isCorrect =
                                              await RidesRepository()
                                                  .checkRideCode(
                                                      rides['creator'],
                                                      int.parse(value));
                                          FocusScope.of(context).unfocus();
                                          if (isCorrect) {
                                            Map<String, dynamic> newRide = {
                                              'address': rides['address'],
                                              'code': rides['code'],
                                              'partner': rides['partner'],
                                              'pets': rides['pets'],
                                              'status': 'accepted',
                                              'creator': rides['creator'],
                                              'date': rides['date'],
                                              'time': rides['time'],
                                            };
                                            RidesRepository().updateRide(
                                                document.id, newRide);
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  'Validation réussie'),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              action: SnackBarAction(
                                                label: 'Fermer',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            final snackBar = SnackBar(
                                              content:
                                                  const Text('Code eronné'),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              action: SnackBarAction(
                                                label: 'Fermer',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        onTap: () {
                                          setState(() {
                                            isUpdating = index;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Color.fromRGBO(
                                              162, 155, 254, 0.2),
                                          hintText: 'Entrer le code',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<userdb.User?>(
                                        future: UsersRepository()
                                            .getUserById(rides['creator']),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<userdb.User?>
                                                snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text(
                                                'Une erreur s\'est produite'); // Afficher un message d'erreur
                                          } else if (snapshot.hasData) {
                                            userdb.User? partner =
                                                snapshot.data;
                                            return Text(
                                                'Proposé par : ${partner?.firstname} ${partner?.lastname}'); // Afficher le nom du partenaire s'il existe, sinon afficher "N/A"
                                          } else {
                                            return const Text(
                                                'Aucune donnée'); // Afficher un message si aucune donnée n'est disponible
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text("Lieux : ${rides['address']}"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ActionChip(
                                            padding: const EdgeInsets.all(2.0),
                                            avatar: const CircleAvatar(
                                              backgroundColor: Color.fromRGBO(
                                                  156, 136, 255, 0),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 20,
                                              ),
                                            ),
                                            label: const Text(
                                              'Valider',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            onPressed: () async {
                                              bool isCorrect =
                                                  await RidesRepository()
                                                  .checkRideCode(
                                                  rides['creator'],
                                                  int.parse(_textDefaultController.value.text));
                                              if (isCorrect) {
                                                Map<String, dynamic> newRide = {
                                                  'address': rides['address'],
                                                  'code': rides['code'],
                                                  'partner': rides['partner'],
                                                  'pets': rides['pets'],
                                                  'status': 'accepted',
                                                  'creator': rides['creator'],
                                                  'date': rides['date'],
                                                  'time': rides['time'],
                                                };
                                                RidesRepository().updateRide(
                                                    document.id, newRide);
                                                final snackBar = SnackBar(
                                                  content: const Text(
                                                      'Validation réussie'),
                                                  backgroundColor: Theme.of(context)
                                                      .primaryColor,
                                                  action: SnackBarAction(
                                                    label: 'Fermer',
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                final snackBar = SnackBar(
                                                  content:
                                                  const Text('Code eronné'),
                                                  backgroundColor: Theme.of(context)
                                                      .primaryColor,
                                                  action: SnackBarAction(
                                                    label: 'Fermer',
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                              FocusScope.of(context)
                                                  .requestFocus(_focusNode);
                                              FocusScope.of(context).unfocus();
                                            },
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    196, 255, 227, 1),
                                          ),
                                          ActionChip(
                                            padding: const EdgeInsets.all(2.0),
                                            avatar: const CircleAvatar(
                                              backgroundColor: Color.fromRGBO(
                                                  156, 136, 255, 0),
                                              child: Icon(
                                                Icons.cancel_outlined,
                                                color: Color.fromRGBO(
                                                    234, 134, 133, 1),
                                                size: 20,
                                              ),
                                            ),
                                            label: const Text(
                                              'Annuler',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      234, 134, 133, 1)),
                                            ),
                                            onPressed: () {},
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    234, 134, 133, 0.2),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      if (_textDefaultController.value.text.isNotEmpty) {
                        _textDefaultController.text = "";
                      }
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                              border: const GradientBoxBorder(
                                gradient: LinearGradient(colors: [
                                  Colors.blueAccent,
                                  Colors.deepPurpleAccent,
                                  Colors.deepPurple
                                ]),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  color:
                                      const Color.fromRGBO(220, 221, 225, 0.5),
                                  child: Center(
                                    child: TextFormField(
                                      controller: _textDefaultController,
                                      focusNode: _focusNode,
                                      keyboardType: TextInputType.number,
                                      onFieldSubmitted: (String value) {
                                        print(value);
                                      },
                                      onTap: () {
                                        setState(() {
                                          isUpdating = index;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(162, 155, 254, 0.2),
                                        hintText: 'Entrer le code',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder<userdb.User?>(
                                      future: UsersRepository()
                                          .getUserById(rides['creator']),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<userdb.User?>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'Une erreur s\'est produite'); // Afficher un message d'erreur
                                        } else if (snapshot.hasData) {
                                          userdb.User? partner = snapshot.data;
                                          return Text(
                                              'Proposé par : ${partner?.firstname} ${partner?.lastname}'); // Afficher le nom du partenaire s'il existe, sinon afficher "N/A"
                                        } else {
                                          return const Text(
                                              'Aucune donnée'); // Afficher un message si aucune donnée n'est disponible
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("Lieux : ${rides['address']}"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ActionChip(
                                          padding: const EdgeInsets.all(2.0),
                                          avatar: const CircleAvatar(
                                            backgroundColor: Color.fromRGBO(
                                                156, 136, 255, 0),
                                            child: Icon(
                                              Icons.cancel_outlined,
                                              color: Color.fromRGBO(
                                                  234, 134, 133, 1),
                                              size: 20,
                                            ),
                                          ),
                                          label: const Text(
                                            'Annuler',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    234, 134, 133, 1)),
                                          ),
                                          onPressed: () {},
                                          backgroundColor: const Color.fromRGBO(
                                              234, 134, 133, 0.2),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: widget.ridesPastCollection,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Erreur lors de la récupération des balades');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Recuperation en cours");
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document =
                    snapshot.data!.docs[index];
                    final Map<String, dynamic> rides =
                    document.data() as Map<String, dynamic>;
                    Future<userdb.User?> partner =
                    UsersRepository().getUserById(rides['partner']);
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                            border: const GradientBoxBorder(
                              gradient: LinearGradient(colors: [
                                Colors.blueAccent,
                                Colors.deepPurpleAccent,
                                Colors.deepPurple
                              ]),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    color: const Color.fromRGBO(220, 221, 225, 0.5),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Code de validation',
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${rides['code']}',
                                            style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<userdb.User?>(
                                    future: UsersRepository()
                                        .getUserById(rides['partner']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<userdb.User?> snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Une erreur s\'est produite'); // Afficher un message d'erreur
                                      } else if (snapshot.hasData) {
                                        userdb.User? partner = snapshot.data;
                                        return Text(
                                            'Accepté par : ${partner?.firstname} ${partner?.lastname}'); // Afficher le nom du partenaire s'il existe, sinon afficher "N/A"
                                      } else {
                                        return const Text(
                                            'Aucune donnée'); // Afficher un message si aucune donnée n'est disponible
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Lieux : ${rides['address']}"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: NavBar(
          // Bottom sheet navigation
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
