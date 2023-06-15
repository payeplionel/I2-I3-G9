import 'package:i2_i3_g9/app/models/address.dart';
import 'package:i2_i3_g9/app/models/pet.dart';
import 'package:i2_i3_g9/app/models/rides.dart';

class User {
  String email;
  String firstname;
  String lastname;
  String gender;
  String password;
  bool verification = false;
  Address address;
  String number;
  String image;
  // Map<String,Pets> pets;
  // List<Rides> rides;

  User({
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.gender,
    required this.password,
    required this.address,
    required this.number,
    required this.image
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'firstname': firstname,
    'lastname': lastname,
    'gender': gender,
    'password': password,
    'verification': verification,
    'address': address.toJson(),
    'number': number,
    'image': image,
    // 'pets': _petsList(pets),
    // 'rides': _ridesList(rides),
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      gender: json['gender'] as String,
      password: json['password'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      number: json['number'] as String,
      image: json['image'] as String
      // pets: _convertPets(json['pets'] as Map<String, dynamic>),
      // rides: _convertRides(json['rides'] as Map<String, dynamic>),
    );
  }

  static Map<String, Pet> _convertPets(Map<String, dynamic> petsMap) {
    final pets = <String, Pet>{};

    petsMap.forEach((key, value) {
      pets[key] = Pet.fromJson(value as Map<String, dynamic>);
    });

    return pets;
  }


  static List<Rides> _convertRides(Map<String, dynamic> ridesMap) {
    final rides = <Rides>[];

    ridesMap.forEach((key, value) {
      rides.add(Rides.fromJson(value as Map<String, dynamic>));
    });

    return rides;
  }

  List<Map<String, dynamic>>? _petsList(Map<String, Pet>? pets) {
    if (pets == null) {
      return null;
    }
    final petsMap = <Map<String, dynamic>>[];
    pets.forEach((key, value) {
      petsMap.add(value.toJson());
    });
    return petsMap;
  }

  List<Map<String, dynamic>>? _ridesList(List<Rides>? rides) {
    if (rides == null) {
      return null;
    }
    final ridesMap = <Map<String, dynamic>>[];
    for (var ride in rides) {
      ridesMap.add(ride.toJson());
    }
    return ridesMap;
  }
}
