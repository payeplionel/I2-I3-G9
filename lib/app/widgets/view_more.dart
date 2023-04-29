import 'package:flutter/material.dart';

class ViewMore extends StatelessWidget {
  const ViewMore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(left: 30.0, top: 2.0, right: 10.0),
            height: 60,
            child: Row(
              // Nom et Prenom de la personne qui propose la balade
              children: const [
                Text(
                  "PRENOM",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "NOM",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                  children: const [
                    Text(
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
                        backgroundColor: Color.fromRGBO(87, 75, 144, 0.1),
                        avatar: Icon(
                          Icons.calendar_month_sharp,
                          color: Color.fromRGBO(87, 75, 144, 1),
                        ),
                        label: Text(
                          '12 feb · 16h00',
                          style:
                              TextStyle(color: Color.fromRGBO(87, 75, 144, 1)),
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
                    "Compagnons de balade : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Wrap(
                  // Liste de compagnons présents dans cette balade
                  spacing: 10.0,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: const [
                    Chip(
                      backgroundColor: Color.fromRGBO(87, 75, 144, 0.1),
                      avatar: Text("🐶"),
                      label: Text(
                        'Max',
                        style: TextStyle(color: Color.fromRGBO(87, 75, 144, 1)),
                      ),
                    ),
                    Chip(
                      backgroundColor: Color.fromRGBO(87, 75, 144, 0.1),
                      avatar: Text("😸"),
                      label: Text(
                        'Lucie',
                        style: TextStyle(color: Color.fromRGBO(87, 75, 144, 1)),
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
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text:
                          "Mon chien est grand et noir. Il a quatre pattes avec les griffes, les longues oreilles et une queue assez longue qu’il remue pour s’exprimer son amour et affection. Il lèche du lait avec sa langue et il aime les biscuits.",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          wordSpacing: 2.0),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Accepter',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            )),
          ],
        )
      ],
    );
  }
}
