

import 'package:cloud_firestore/cloud_firestore.dart';

class Rides {
  Rides({
    required this.address,
    required this.code, // code unique pour chaque chaque promenade avec le status 'in progress'
    required this.partner,
    required this.pets,
    required this.status,
    required this.creator,
    required this.date,
    required this.time,

    /* statut de la balade :
        - 'available' pour les promenades qui sont disponible
        - 'in progress' pour les promenades qui ont trouvé un preneur
        - 'canceled' pour les promenades annulées par le créateur
     */
  });

  String address;
  String code;
  String partner;
  List<String> pets;
  String status;
  String creator;
  Timestamp date;
  Timestamp time;





  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
        'code': code,
        'partner': partner,
        'pets': _petsList(pets),
        'status': status,
        'creator': creator,
        'date': date,
        'time': time,
      };

  factory Rides.fromJson(Map<String, dynamic> json) {
    return Rides(
      address: json['address'] as String,
      code: json['code'] as String,
      partner: json['partner'] as String,
      pets: List<String>.from(json['pets']),
      status: json['status'] as String,
      creator: json['creator'] as String,
      time: json['time'] as Timestamp,
      date: json['date'] as Timestamp,
    );
  }

  List<String> _petsList(List<String> pets) {
    List<String> petsMap = [];

    for (var pet in pets) {
      petsMap.add(pet);
    }

    return petsMap;
  }

  @override
  String toString() {
    return 'Rides{address: $address, code: $code, partner: $partner, pets: $pets, status: $status, creator: $creator, date: $date, time: $time}';
  }
}
