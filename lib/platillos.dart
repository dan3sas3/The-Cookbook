import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookbook_app/platillo_detalles.dart';

import 'homepage.dart';
import 'model/platillo_model.dart';
import 'nuevo_platillo.dart';

class PantallaPlatillos extends StatefulWidget {
  final String id_cookbook;
  PantallaPlatillos({Key ? key, required this.id_cookbook}):super(key:key);

  @override
  _PantallaPlatillosState createState() => _PantallaPlatillosState();

}

class _PantallaPlatillosState extends State<PantallaPlatillos> {
  User? user = FirebaseAuth.instance.currentUser;
  List platillos = <Map>[];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
      .collection("usuarios")
      .doc(user!.uid)
      .collection("cookbooks")
      .doc(widget.id_cookbook)
      .collection("platillos")
      .get()
      .then((querySnapshot){
        querySnapshot.docs.forEach((result) {
          PlatilloModel cookbookModel =  PlatilloModel.fromDocument(result);
          platillos.add({
              'pid':cookbookModel.pid,
              'nombre_platillo':cookbookModel.nombre_platillo,
              'imagen_portada':cookbookModel.imagen_portada,
            });
         });
         setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Platillos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.pushAndRemoveUntil(
              (context), 
              MaterialPageRoute(builder: (context)=>HomeScreen()), 
              (route) => false
            );
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column (
          children: [
            /*Card(
              child: Text(widget.id_cookbook),
            ),*/
            /*resultados.isEmpty 
            ? const Card(
              child: Text('resultados vacios'),
            )
            : const Card(
              child: Text('resultados no vacios')
            ),*/
             for(var platillo in platillos) Card(
              child: ListTile(
                leading: Image.network(
                  platillo['imagen_portada'],
                  height: 100,
                  width: 100,
                ), 
                title: Text(platillo['nombre_platillo']),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaDetallesPlatillo(id_platillo: platillo['pid'],id_cookbook: widget.id_cookbook)
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => crearPlatillo(id_cookbook: widget.id_cookbook,)
                    )
                  );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}