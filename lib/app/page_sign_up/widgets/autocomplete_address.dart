import 'package:flutter/material.dart';

class AutoAddress extends StatelessWidget {
  AutoAddress(
      {Key? key,
      required this.controllerPostal,
      required this.valueChange,
      required this.controllerNumber,
      required this.controllerCity,
      required this.controllerStreet,
      required this.addressChanged})
      : super(key: key);
  final TextEditingController controllerPostal;
  final TextEditingController controllerStreet;
  final TextEditingController controllerCity;
  final TextEditingController controllerNumber;
  Function addressChanged;
  Function valueChange;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
              controller: controllerCity,
              onChanged: (value) {
                addressChanged();
              },
              style: TextStyle(fontSize: screenHeight * 0.02),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                hintText: 'Ville',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextField(
              controller: controllerPostal,
              onChanged: (value) {
                addressChanged();
              },
              style: TextStyle(fontSize: screenHeight * 0.02),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                hintText: 'Code postal',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: controllerNumber,
                onChanged: (value) {
                  addressChanged();
                },
                style: TextStyle(fontSize: screenHeight * 0.02),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                  hintText: 'N°',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              flex: 8,
              child: TextField(
                controller: controllerStreet,
                onChanged: (value) {
                  addressChanged();
                },
                style: TextStyle(fontSize: screenHeight * 0.02),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(162, 155, 254, 0.2),
                  hintText: 'rue',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
