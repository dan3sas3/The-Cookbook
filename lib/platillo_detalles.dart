import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook_app/anadir_receta.dart';
import 'package:cookbook_app/editar_platillo.dart';
import 'package:cookbook_app/nuevo_punto_mapa.dart';
import 'package:cookbook_app/platillos.dart';
import 'package:cookbook_app/ver_en_mapa.dart';
import 'package:cookbook_app/ver_receta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class PantallaDetallesPlatillo extends StatelessWidget {
  final String id_platillo;
  final String id_cookbook;
  PantallaDetallesPlatillo({Key ? key, required this.id_platillo, required this.id_cookbook}):super(key:key);
  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    CollectionReference platillos = FirebaseFirestore.instance
      .collection("usuarios")
      .doc(user!.uid)
      .collection("cookbooks")
      .doc(id_cookbook)
      .collection("platillos");
    return FutureBuilder<DocumentSnapshot>(
      future: platillos.doc(id_platillo).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.hasError){
          return const Text("Algo salió mal");
        }
        if(snapshot.hasData && !snapshot.data!.exists){
          return const Text("No existe el documento");
        }
        if(snapshot.connectionState==ConnectionState.done){
          Map<String, dynamic> platillo = snapshot.data!.data() as Map<String,dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Mis Platillos"),
              leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: (){
                Navigator.pushAndRemoveUntil(
                  (context), 
                  MaterialPageRoute(builder: (context)=>PantallaPlatillos(id_cookbook: id_cookbook,)), 
                  (route) => false
                );
              },
        ),
            ),
            body: Container(
              margin: const EdgeInsets.all(8.0),
              child: Column (
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text(
                            platillo['nombre_platillo'],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40
                            ),
                          )
                        ]
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const [
                          Text(
                            'Información General',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: Image.network(
                              platillo['imagen_portada'],
                              height: 250,
                              width: 250,
                            ),
                          )
                        ],
                      ),
                      !platillo.containsKey('restaurante')||platillo['restaurante']=='' ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const [
                          Expanded(child:Text(
                            'Aún no se ha seleccionado un restaurante para este platillo',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                            ),
                          ))
                        ]
                      ) :Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Restaurante: '+platillo['restaurante'],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]
                      ),
                      const Divider(),
                      !platillo.containsKey('precio')||platillo['precio']=='' ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const [
                          Text(
                            'Aún no se ha seleccionado un precio para este platillo',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                            ),
                          )
                        ]
                      ) :Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Precio del platillo: '+platillo['precio'].toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]
                      ),
                      !platillo.containsKey('telefono_restaurante')||platillo['telefono_restaurante']=='' ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const [
                          Text(
                            'Aún no se ha indicado un telefono',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                            ),
                          )
                        ]
                      ) :Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tel: '+platillo['telefono_restaurante'].toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              String url = 'tel:+52'+platillo['telefono_restaurante'];
                              if (await canLaunch(url)){
                                await launch(url);
                              }else{
                                throw 'error al llamar a $url';
                              }
                            }, 
                            icon: Icon(Icons.phone)
                          )
                        ]
                      ),
                      const Divider(),
                      !platillo.containsKey('ubicacion')||platillo['ubicacion']=='' ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => PantallaMaps(id_cookbook: id_cookbook, id_platillo: id_platillo)
                              ));
                            }, 
                            child: const Text('Añadir ubicacion en mapa')
                          )
                        ]
                      ) :  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                String restaurante;
                                if(platillo['restaurante']==null){
                                  restaurante = 'Restaurante';
                                }else{
                                  restaurante = platillo['restaurante'];
                                }
                                Navigator.push(context, MaterialPageRoute(
                                builder: (context) => VerMaps(latitud: platillo['ubicacion']['latitud'], longitud: platillo['ubicacion']['longitud'], nombreRestaurante:restaurante,)
                              ));
                              }, 
                              child: const Text('Ver en maps')
                          )
                        ]
                      ),
                      const Divider(),
                      !platillo.containsKey('receta')||platillo['receta']=='' ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute(
                                  builder: (context) => crearReceta(id_cookbook: id_cookbook, id_platillo: id_platillo,),
                                )
                              );
                            }, 
                            child: const Text('Añadir Receta')
                          )
                        ]
                      ) :  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute(
                                  builder: (context) => VerReceta(id_cookbook: id_cookbook, id_platillo: id_platillo,),
                                )
                              );
                            }, 
                            child: const Text('Ver Receta')
                          )
                        ]
                      ),
                      const Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                              Navigator.push(context,MaterialPageRoute(
                                  builder: (context) => editarPlatillo(id_cookbook: id_cookbook, id_platillo: id_platillo,),
                                )
                              );
                              }, 
                              child: const Text('Editar información')
                            )
                          ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }//if connection state
        return const Text("Cargando...");
      }//builder function
    );
  }
}
