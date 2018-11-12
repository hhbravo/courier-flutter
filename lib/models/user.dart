class User {
  String _username;
  String _password;
  String usuario;
  int idusuario;
  String idperfil;
  String idempleado;
  String nombres;
  String apellidos;

  User({
    this.usuario,
    this.idusuario,
    this.idperfil,
    this.idempleado,
    this.nombres,
    this.apellidos
    }
  );

  User.map(dynamic obj) {
    this._username = obj["user"];
    this._password = obj["password"];
  }

  String get username => _username;
  String get password => _password;
  String get name => nombres;
  String get lastname => apellidos;
  int get key => idusuario;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["user"] = _username;
    map["password"] = _password;
    return map;
  }

  Map<String, dynamic> toMapUser() {
    var map = new Map<String, dynamic>();
    map["idusuario"] = idusuario;
    map["nombres"] = name;
    map["apellidos"] = lastname;
    return map;
  }

   factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      usuario: json['usuario'],
      idusuario: int.parse
      (json['idusuario']),
      idperfil: json['idperfil'],
      idempleado: json['idempleado'],
      nombres: json['nombres'],
      apellidos: json['apellidos']
    );
  }

  factory User.fromJsonQuery(Map<String, dynamic> json) {
    return new User(
      idusuario: json['idusuario'],
      nombres: json['nombres'],
      apellidos: json['apellidos']
      
    );
  }
}