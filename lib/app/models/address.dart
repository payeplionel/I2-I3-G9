class Address {
  Address(
      {required this.city,
      required this.country,
      required this.number,
      required this.postal,
      required this.street});
  final String city;
  final String country;
  final String number;
  final String postal;
  final String street;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'city': city,
        'country': country,
        'number': number,
        'street': street,
        'postal': postal,
      };

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String,
      country: json['country'] as String,
      number: json['number'] as String,
      street: json['street'] as String,
      postal :json['postal'] as String,
    );
  }

  @override
  String toString() {
    return '$number $street $postal $city $country';
  }
}
