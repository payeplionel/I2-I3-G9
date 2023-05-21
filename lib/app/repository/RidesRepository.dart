import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:i2_i3_g9/app/models/pets.dart';
import 'package:i2_i3_g9/app/models/rides.dart';

class RidesRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('rides');

  Stream<QuerySnapshot> getRidesForUser(String userId) {
    return collection.where('creator', isNotEqualTo: 'userId').snapshots();
  }

  Future<DocumentReference> addRide(Rides ride) {
    return collection.add(ride.toJson());
  }

  Future<String> isAvailableOrNot(DateTime time, String userId,
      List<String> petsSelected) async {
    String result = '';
    for (var petId in petsSelected) {
      final query = collection
          .where('creator', isEqualTo: userId)
          .where('pets', arrayContains: petId)
          .where('date',
          isGreaterThanOrEqualTo: time.subtract(const Duration(hours: 3)))
          .where('date', isLessThanOrEqualTo: time.add(const Duration(hours: 3)));
      final querySnap = await query.get();
      final documents = querySnap.docs;
      if (documents.isNotEmpty) {
        DocumentSnapshot petDocument = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('pets')
            .doc(petId)
            .get();
        if (petDocument.exists) {
          final Map<String, dynamic> data =
          petDocument.data() as Map<String, dynamic>;
          final Pets pet = Pets.fromJson(data);
          result += ' ${pet.name},';
        }
      }
    }
    if(result.isNotEmpty){
      result = result.substring(0, result.length - 1);
    }
   return result;
  }
}
