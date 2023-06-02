import 'package:flutter/material.dart';

class SignAuth extends StatelessWidget {
  SignAuth({
    Key? key,
    required this.navigationSign,
    required this.controllerEmail,
    required this.controllerPassword,
    required this.controllerPasswordVerif,
  }) : super(key: key);

  Function navigationSign;
  TextEditingController controllerEmail;
  TextEditingController controllerPassword;
  TextEditingController controllerPasswordVerif;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final _formKey = GlobalKey<FormState>();


    return  Column(
      children: [
        const Text(
          "Veuillez entrer vos informations de connexion",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          style: TextStyle(fontSize: screenHeight * 0.02),
          controller: controllerEmail,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(162, 155, 254, 0.2),
            hintText: 'Email',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          style: TextStyle(fontSize: screenHeight * 0.02),
          controller: controllerPassword,
          obscureText: true,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(162, 155, 254, 0.2),
            hintText: 'Mot de passe',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          style: TextStyle(fontSize: screenHeight * 0.02),
          controller: controllerPasswordVerif,
          obscureText: true,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(162, 155, 254, 0.2),
            hintText: 'Vérifier votre mot de passe',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                navigationSign(1);
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Retour',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: screenHeight * 0.02,
                  ),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                // if (Form.of(context)!.validate()) {
                //   // navigationSign(3);
                // }
                navigationSign(3);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Continuer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.02,
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
