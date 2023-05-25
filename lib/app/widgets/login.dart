import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view/dogs_ride.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text;
                final password = _passwordController.text;

                // TODO: Handle login logic
                _loginWithEmailAndPassword(username, password, context);
              },
              child: const Text('Login'),
            ),
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
          .signInWithEmailAndPassword(
          email: username, password: password);

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
