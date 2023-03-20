import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/widgets/list_rides.dart';
import 'package:i2_i3_g9/app/widgets/map_overview.dart';

class DogsRide extends StatefulWidget {
  const DogsRide({Key? key}) : super(key: key);

  @override
  State<DogsRide> createState() => _DogsRideState();
}

class _DogsRideState extends State<DogsRide> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Column(
          children: [
            Expanded(child: MapOverview()),
            Container(
              color: Colors.blue.shade50,
              height: screenHeight * 0.5,
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext contextn, int index){
                  return Container(
                    height: 50,
                    color: Colors.amber[colorCodes[index]],
                    child: Center(child: Text('Entry ${entries[index]}')),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
            )
          ],
    ));
  }
}
