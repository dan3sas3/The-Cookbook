import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class VerReceta extends StatelessWidget {
  final String id_platillo;
  final String id_cookbook;
  VerReceta({Key ? key, required this.id_platillo, required this.id_cookbook}):super(key:key);
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
                        children:const[
                          Text(
                            'Receta',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40
                            ),
                          )
                        ]
                      ),
                      const Divider(),
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
                            'Ingredientes',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),
                          )
                        ]
                      ),
                      const Divider(),
                      for(var i in platillo['receta']['ingredientes'])Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              i,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Tiempo de preparación:',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            platillo['receta']['tiempo'],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Preparación',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),
                            maxLines: null
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              platillo['receta']['preparacion'],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 12
                              ),
                            ),
                          )
                        ],
                      ),
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
