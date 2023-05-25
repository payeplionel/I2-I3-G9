import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i2_i3_g9/app/models/pet.dart';
import 'package:i2_i3_g9/app/models/ride.dart';

class RidesRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('rides');

  Stream<QuerySnapshot> getRidesForUser(String userId) {
    return collection
        .where('creator', isNotEqualTo: userId)
        .where('status', isEqualTo: 'available')
        .snapshots();
  }

  Future<DocumentReference> addRide(Rides ride) {
    return collection.add(ride.toJson());
  }

  Future<QuerySnapshot<Object?>> getPetsOfRide(Rides ride) async {
    CollectionReference userPetsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(ride.creator)
        .collection('pets');
    QuerySnapshot<Object?> querySnapshot = await userPetsCollection
        .where(FieldPath.documentId, whereIn: ride.pets)
        .get();

    return querySnapshot;
  }

  Future<String> isAvailableOrNot(
      DateTime time, String userId, List<String> petsSelected) async {
    String result = '';
    for (var petId in petsSelected) {
      final query = collection
          .where('creator', isEqualTo: userId)
          .where('pets', arrayContains: petId)
          .where('date',
              isGreaterThanOrEqualTo: time.subtract(const Duration(hours: 3)))
          .where('date',
              isLessThanOrEqualTo: time.add(const Duration(hours: 3)));
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
    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  void updateRide(String documentId, Map<String, dynamic> ride) {
    collection.doc(documentId).update(ride).then((value) {
      print("Document updated successfully");
    }).catchError((error) {
      print("Failed to update document: $error");
    });
  }
}
