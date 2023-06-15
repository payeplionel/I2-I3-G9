import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i2_i3_g9/app/models/pet.dart';
import 'package:i2_i3_g9/app/models/rides.dart';

import '../utils/constants.dart';
import '../utils/network_util.dart';

class RidesRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('rides');

  Stream<QuerySnapshot> getRidesForUser(String userId) {
    return collection
        .where('creator', isNotEqualTo: userId)
        .where('status', isEqualTo: 'available')
        .snapshots();
  }

  Stream<QuerySnapshot> getRidesCreateByUser(String userId) {
    return collection
        .where('creator', isEqualTo: userId)
        .where('status', isEqualTo: 'available')
        .snapshots();
  }

  Stream<QuerySnapshot> getRidesDidByUser(String userId) {
    return collection
        .where('partner', isEqualTo: userId)
        .where('status', isEqualTo: 'in progress')
        .snapshots();
  }

  Future<bool> checkRideCode(String userId, int code) async {
    QuerySnapshot querySnapshot = await collection
        .where('creator', isEqualTo: userId)
        .where('code', isEqualTo: code).get();

    return querySnapshot.size > 0;
  }

  Stream<QuerySnapshot> getPastRidesForUser(String userId) {
    return collection
        .where('creator', isEqualTo: userId)
        .snapshots();
  }


  Stream<QuerySnapshot> getProgressRidesForUser(String userId) {
    return collection
        .where('creator', isEqualTo: userId)
        .where('status', isEqualTo: 'in progress')
        .snapshots();
  }

  Future<DocumentReference> addRide(Rides ride) {
    return collection.add(ride.toJson());
  }

  Future<QuerySnapshot<Object?>> getPetsOfRide(Rides ride) async {
    CollectionReference userPetsCollection = FirebaseFirestore.instance
        .collection('user')
        .doc(ride.creator)
        .collection('pet');
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
            .collection('user')
            .doc(userId)
            .collection('pet')
            .doc(petId)
            .get();
        if (petDocument.exists) {
          final Map<String, dynamic> data =
              petDocument.data() as Map<String, dynamic>;
          final Pet pet = Pet.fromJson(data);
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

  // Future<void> placeAutocomplete(String query) async {
  //   Uri uri = Uri.https("maps.googleapis.com",
  //       "maps/api/place/autocomplete/json", {"input": query, "key": apiKey});
  //   String? response = await NetworkUtils.fetchUrl(uri);
  //   print(response);
  //   if (response != null) {}
  // }

  Future<List<String>> placeAutocomplete(String query) async {

    Uri uri = Uri.https("maps.googleapis.com",
        "maps/api/place/autocomplete/json", {"input": query, "key": apiKey});
    String? response = await NetworkUtils.fetchUrl(uri);

    if (response != null) {
      List<String> results = parseAutocompleteResponse(response);

      return results;
    } else {
      return [];
    }
  }

  List<String> parseAutocompleteResponse(String response) {
    // Convertir la chaîne de réponse en un objet JSON
    Map<String, dynamic> jsonResponse = json.decode(response);

    // Vérifier si la réponse contient la clé "predictions" (prédictions)
    if (jsonResponse.containsKey("predictions")) {
      // Extraire la liste des prédictions
      List<dynamic> predictions = jsonResponse["predictions"];

      // Parcourir les prédictions et extraire les descriptions
      List<String> address = [];
      List results = predictions.map((prediction) {
        address.add(prediction["description"]);
        return prediction["description"];
      }).toList();

      return address;
    } else {
      return [];
    }
  }


}
