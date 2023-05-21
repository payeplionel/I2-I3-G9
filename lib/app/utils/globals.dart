class Globals {
  static final Globals _instance = Globals._internal();

  factory Globals() {
    return _instance;
  }

  Globals._internal();

  // Ajoutez vos variables globales ici
  String idUser = 'w86XXxYwInbWb8SM4dt7';
}

// // Utilisation :
// Globals().myGlobalVariable = 'nouvelle valeur';
// print(Globals().myGlobalVariable);
