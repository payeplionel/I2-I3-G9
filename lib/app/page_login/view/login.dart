import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i2_i3_g9/app/page_sign_up/view/sign_up_page.dart';
import 'package:i2_i3_g9/app/utils/globals.dart';
import '../../page_dogs_ride/view/dogs_ride.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0),
        child: ListView(
          children: [
            Row(
              children: const [
                Text('Pets Kart Tour',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                        color: Color.fromRGBO(44, 58, 71, 1))),
              ],
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/pets.gif',
              width: screenHeight * 0.2,
              height: screenHeight * 0.2,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              style: TextStyle(fontSize: screenHeight * 0.02),
              decoration: InputDecoration(
                suffixIcon:
                    Icon(Icons.mail, color: Theme.of(context).primaryColor),
                labelText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              enabled: true,
              style:
                  TextStyle(fontSize: screenHeight * 0.02, color: Colors.red),
              obscureText: true,
              decoration: InputDecoration(
                suffixIcon:
                    Icon(Icons.key, color: Theme.of(context).primaryColor),
                labelText: 'Mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Mot de passe oublié ?",
                    style: TextStyle(color: Theme.of(context).primaryColor))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: screenHeight * 0.08,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final username = _usernameController.text;
                        final password = _passwordController.text;

                        // TODO: Handle login logic
                        _loginWithEmailAndPassword(username, password, context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Se connecter',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.02),
                          )),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text("Continuer avec")],
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              'assets/images/google.png',
              width: 75,
              height: 75,
            ),
            Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Créer un compte',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: screenHeight * 0.02),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _loginWithEmailAndPassword(
      String username, String password, BuildContext context) async {
    try {
      // Utilisez votre logique de connexion avec votre base de données ici
      // Par exemple, si vous utilisez Firebase Firestore pour l'authentification,
      // vous pouvez utiliser la méthode signInWithEmailAndPassword de FirebaseAuth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
      String? userid = userCredential.user?.uid;
      Globals().idUser = userid!;
      print(userid);
      // Connexion réussie, redirigez l'utilisateur vers la page d'accueil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DogsRide()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // L'utilisateur n'existe pas dans la base de données
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur de connexion'),
              content: const Text('L\'utilisateur n\'existe pas.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        // Mot de passe incorrect
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur de connexion'),
              content: const Text('Mot de passe incorrect.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
