import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i2_i3_g9/app/models/address.dart';
import 'package:i2_i3_g9/app/models/user.dart' as userdb;
import 'package:i2_i3_g9/app/utils/globals.dart';
import '../models/pet.dart';
import '../models/rides.dart';

class UsersRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user');

  Stream<QuerySnapshot> getPetsOfUserStream(String userId) {
    return collection.doc(userId).collection('pet').snapshots();
  }

  Future<void> addUser(userdb.User user, List<Pet> petsList) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      // Utilisez userCredential.user pour obtenir l'utilisateur authentifié
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .set(user.toJson());
      String? userId = userCredential.user?.uid;
      for (var pet in petsList) {
        addPet(pet, userId!);
      }
      print('Utilisateur ajouté avec succès');
    } catch (error) {
      print('Erreur lors de l\'ajout de l\'utilisateur: $error');
    }
  }

  Future<void> addPet(Pet pet, String userId) async {
    DocumentReference petRef = FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('pet')
        .doc();

    Map<String, dynamic> petData = {
      'referenceId': petRef.id,
      'name': pet.name,
      'breed': pet.breed,
      'type': pet.type,
      'age': pet.age,
      'description': pet.description,
    };

    await petRef.set(petData);
  }

  Future<void> addRide(Rides ride, String userId) async {
    DocumentReference petRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('rides')
        .doc();

    Map<String, dynamic> petData = {
      'address': ride.address,
      'code': ride.code,
      'partner': ride.partner,
      'pets': ride.pets,
      'status': ride.status,
    };

    await petRef.set(petData);
  }

  Future<Address?> getAddressById(String userId) async {
    DocumentSnapshot documentSnapshot = await collection.doc(userId).get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      final Address address = Address.fromJson(data['address']);
      return address;
    }
    return null;
  }

  Future<userdb.User?> getUserById(String userId) async {
    DocumentSnapshot documentSnapshot = await collection.doc(userId).get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      final userdb.User user = userdb.User.fromJson(data);
      return user;
    }
    return null;
  }

  Future<Map<String, dynamic>?> findDocUserById(String userId) async {
    // Recuperation du document par son ID
    DocumentSnapshot documentSnapshot = await collection.doc(userId).get();

    // Vérification si le document existe
    if (documentSnapshot.exists) {
      // Utilisez les données du document ici
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return data;
    }
    return null;

  }

  void updateUser(userdb.User user) async {
    // Obtenez une référence au document que vous souhaitez mettre à jour
    DocumentReference documentRef =
    collection.doc(Globals().idUser);

    try {
      // Effectuez la mise à jour du document
      await documentRef.update(user.toJson());
      print('Document mis à jour avec succès');
    } catch (error) {
      print('Erreur lors de la mise à jour du document : $error');
    }
  }
}
