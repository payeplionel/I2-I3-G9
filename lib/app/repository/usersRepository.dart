import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i2_i3_g9/app/models/address.dart';
import 'package:i2_i3_g9/app/models/user.dart';
import '../models/pet.dart';
import '../models/ride.dart';

class UsersRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getPetsOfUserStream(String userId) {
    return collection.doc(userId).collection('pets').snapshots();
  }

  Future<DocumentReference> addUser(Users user){
    return collection.add(user.toJson());
  }

  Future<void> addPet(Pets pet, String userId) async {
    DocumentReference petRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('pets')
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
    DocumentSnapshot documentSnapshot = await collection.doc(userId)
        .get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      final Address address = Address.fromJson(data['address']);
      return address;
    }
    return null;
  }

  Future<Users?> getUserById(String userId) async {
    DocumentSnapshot documentSnapshot = await collection.doc(userId)
        .get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      final Users user = Users.fromJson(data);
      return user;
    }
    return null;
  }

}