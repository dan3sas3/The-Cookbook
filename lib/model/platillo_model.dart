import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlatilloModel{
  String? pid;
  String? nombre_platillo;
  String? imagen_portada;

  PlatilloModel({this.pid,this.nombre_platillo, this.imagen_portada});
  //PlatilloModel({this.nombre_cookbook, this.imagen_portada});
  factory PlatilloModel.fromDocument(DocumentSnapshot documentSnapshot){
    return PlatilloModel(
      pid: documentSnapshot['pid'],
      nombre_platillo: documentSnapshot['nombre_platillo'],
      imagen_portada: documentSnapshot['imagen_portada']
    );
  }
  Map<String, dynamic> toMap(){
    return{
      'pid':pid,
      'nombre_cookbook':nombre_platillo,
      'imagen_portada':imagen_portada
    };
  }
}