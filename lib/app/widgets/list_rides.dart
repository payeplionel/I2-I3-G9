import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/widgets/view_more.dart';

class ListRide extends StatelessWidget {
  // const ListRide(
  //     {Key? key,
  //     required this.image,
  //     required this.depart,
  //     required this.destination,
  //     required this.onPressedMessage,
  //     required this.onPressedDone})
  //     : super(key: key);
  // final String image;
  // final String depart;
  // final String destination;
  // final Function onPressedMessage;
  // final Function onPressedDone;
  final List<String> entries = <String>['A', 'B', 'C', 'E', 'F', 'G', 'I'];
  final List<int> colorCodes = <int>[600, 500, 100, 200, 300, 200, 50];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 1, right: 1, top: 5),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                      ),
                      builder: (BuildContext context) {
                        return const SizedBox(
                          child: ViewMore(),
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
                      children: const [
                        Text(
                          'Limoges',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Feb12 · 16h00',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '2 Compagnons 🐶 😸',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0
                          ),
                        )
                      ],
                    ),
                  ),
                )),
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
                              Icon(Icons.forum_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 20), // L'icône à gauche
                              const SizedBox(
                                  width:
                                      3), // Un espace de 5 pixels entre l'icône et le texte
                              Text(
                                'Messages',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const Padding(
        padding: EdgeInsets.only(left: 80.0),
        child: Divider(height: 2.0,),
      ),
    );
  }
}

// Row(
// // mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// margin: const EdgeInsets.all(10.0),
// width: 75.0,
// height: 75.0,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.red[300],
// ),
// ),
// Column(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('Ville'),
// Text('Ville2'),
// ],
// ),
// Container(
// margin: const EdgeInsets.all(10.0),
// child:  Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// OutlinedButton(
// onPressed: () {
// // Action à effectuer lorsque le bouton est cliqué
// },
// style: OutlinedButton.styleFrom(
// backgroundColor: const Color.fromRGBO(217, 217, 217, 0.5),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(20),
// ),
// ),
// child: Row(
// children: const <Widget>[
// Icon(Icons.forum_outlined, color: Colors.black, size: 20), // L'icône à gauche
// SizedBox(width: 3), // Un espace de 5 pixels entre l'icône et le texte
// Text(
// 'Messages',
// style: TextStyle(color: Colors.black, fontSize: 12),
// ),
// ],
// ),
// )
// ],
// ),
// )
// ],
// ),

// return Row(
//   children: [
//     CircleAvatar(child: Text(image)),
//     const SizedBox(width: 16),
//     Container(
//       color: Colors.cyan,
//       child: Column(
//         children: [
//           Text('Depart: $depart', textAlign: TextAlign.right),
//           const SizedBox(height: 40),
//           Text(
//             'Arrivé: $destination',
//             textAlign: TextAlign.right,
//           )
//         ],
//       ),
//     ),
//     const SizedBox(width: 16),
//     Container(
//       color: Colors.blue,
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () {
//               onPressedMessage();
//             },
//             icon: const Icon(Icons.message),
//             color: Colors.blueGrey,
//           ),
//           const SizedBox(width: 1),
//           IconButton(
//             onPressed: () {
//               onPressedDone();
//             },
//             icon: const Icon(Icons.done),
//             color: Colors.greenAccent,
//           ),
//         ],
//       ),
//     )
//   ],
// );
