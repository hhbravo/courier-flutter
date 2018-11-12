class Orders {
  List<Order> orders;

  Orders({this.orders});

  Orders.fromJson(List ordersList) {
    print(ordersList);
    orders = new List<Order>();
    for (int i = 0; i < ordersList.length; i++) {
      orders.add(Order.fromJson(ordersList[i]));
    }
  }
}

class Order {
  String idcourier;
  String annio;
  String nro_orden;
  String prioridad;
  String cliente;
  String contacto;
  String telefono_contacto;
  String idusuario_asignado;
  String direccion;
  String fch_creacion;
  String fch_entrega;
  String latitud;
  String longitud;
  String observaciones;
  String idusuario_crea;

  Order(
      {this.idcourier,
      this.annio,
      this.nro_orden,
      this.prioridad,
      this.cliente,
      this.contacto,
      this.telefono_contacto,
      this.idusuario_asignado,
      this.direccion,
      this.fch_creacion,
      this.fch_entrega,
      this.latitud,
      this.longitud,
      this.observaciones,
      this.idusuario_crea});

  Order.fromJson(Map<String, dynamic> json) {
    idcourier = json['idcourier'];
    annio = json['annio'];
    nro_orden = json['nro_orden'];
    prioridad = json['prioridad'];
    cliente = json['cliente'];
    contacto = json['contacto'];
    telefono_contacto = json['telefono_contacto'];
    idusuario_asignado = json['idusuario_asignado'];
    direccion = json['direccion'];
    fch_creacion = json['fch_creacion'];
    fch_entrega = json['fch_entrega'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    observaciones = json['observaciones'];
    idusuario_crea = json['idusuario_crea'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcourier'] = this.idcourier;
    data['annio'] = this.annio;
    data['nro_orden'] = this.nro_orden;
    data['prioridad'] = this.prioridad;
    data['cliente'] = this.cliente;
    data['contacto'] = this.contacto;
    data['telefono_contacto'] = this.telefono_contacto;
    data['idusuario_asignado'] = this.idusuario_asignado;
    data['direccion'] = this.direccion;
    data['fch_creacion'] = this.fch_creacion;
    data['fch_entrega'] = this.fch_entrega;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['observaciones'] = this.observaciones;
    data['idusuario_crea'] = this.idusuario_crea;
  }
}
