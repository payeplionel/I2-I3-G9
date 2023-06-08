import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i2_i3_g9/app/models/rides.dart';

import '../../repository/RidesRepository.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final RidesRepository _ridesRepository = RidesRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des courses'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _ridesRepository.collection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Une erreur s\'est produite.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final rides = snapshot.data!.docs
                    .map((doc) => Rides.fromJson(doc.data() as Map<String, dynamic>))
                    .toList();

                final inProgressRides =
                rides.where((ride) => ride.status == 'in progress').toList();
                final completedRides =
                rides.where((ride) => ride.status == 'completed').toList();

                return ListView(
                  children: [
                    _buildSectionHeader('En cours'),
                    _buildRideList(inProgressRides),
                    _buildSectionHeader('Terminé'),
                    _buildRideList(completedRides),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRideList(List<Rides> rides) {
    if (rides.isEmpty) {
      return const ListTile(
        title: Text('Aucune course trouvée.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];

        return ListTile(
          title: Text('Adresse: ${ride.address}'),
          subtitle: Text('Code: ${ride.code}'),
          trailing: Text('Statut: ${ride.status}'),
          onTap: () {
            // Actions lorsque l'utilisateur clique sur une course
          },
        );
      },
    );
  }
}
