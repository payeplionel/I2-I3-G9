class Pet{
  Pet({
    required this.type,
    required this.age,
    required this.breed,
    required this.description,
    required this.name, required String referenceId,
  });
  String referenceId = '';
  final String type;
  final int age;
  final String breed;
  final String description;
  final String name;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'referenceId': referenceId,
    'type': type,
    'age': age,
    'breed': breed,
    'description': description,
    'name': name,

  };

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      type: json['type'] as String,
      age: json['age'] as int,
      breed: json['breed'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      referenceId: json['referenceId'] as String,
    );
  }
}