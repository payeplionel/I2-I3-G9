class Address {
  Address(
      {required this.city,
      required this.country,
      required this.number,
      required this.postal,
      required this.street,
      required this.long,
      required this.lat});
  final String city;
  final String country;
  final String number;
  final String postal;
  final String street;
  final double long;
  final double lat;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'city': city,
        'country': country,
        'number': number,
        'street': street,
        'postal': postal,
        'long': long,
        'lat': lat,
      };

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String,
      country: json['country'] as String,
      number: json['number'] as String,
      street: json['street'] as String,
      postal :json['postal'] as String,
      long: json['long'] as double,
      lat: json['lat'] as double,
    );
  }

  @override
  String toString() {
    return '$number $street $postal $city $country';
  }
}
