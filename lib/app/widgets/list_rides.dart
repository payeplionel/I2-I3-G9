import 'package:flutter/material.dart';

class ListRide extends StatelessWidget {
  const ListRide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          const CircleAvatar(child: Text('LP')),
          const SizedBox(width: 16),
          Column(
            children: const [
              Text('Depart: '),
              SizedBox(width: 16),
              Text('Arrivé: ')
            ],
          )
        ],
    );
  }
}
