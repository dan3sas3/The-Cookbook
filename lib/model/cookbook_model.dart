import 'package:cloud_firestore/cloud_firestore.dart';

class CookBookModel{
  String? cid;
  String? nombre_cookbook;
  String? imagen_portada;

  CookBookModel({this.cid,this.nombre_cookbook, this.imagen_portada});
  //CookBookModel({this.nombre_cookbook, this.imagen_portada});
  factory CookBookModel.fromDocument(DocumentSnapshot documentSnapshot){
    return CookBookModel(
      cid: documentSnapshot['cid'],
      nombre_cookbook: documentSnapshot['nombre_cookbook'],
      imagen_portada: documentSnapshot['imagen_portada']
    );
  }
  Map<String, dynamic> toMap(){
    return{
      'cid':cid,
      'nombre_cookbook':nombre_cookbook,
      'imagen_portada':imagen_portada
    };
  }
}