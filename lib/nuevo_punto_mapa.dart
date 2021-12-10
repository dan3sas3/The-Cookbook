import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook_app/platillo_detalles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PantallaMaps extends StatefulWidget {
  final String id_cookbook;
  final String id_platillo;
  PantallaMaps({Key ? key, required this.id_cookbook, required this.id_platillo}):super(key:key);

  @override
  _PantallaMapsState createState() => _PantallaMapsState();
}

class _PantallaMapsState extends State<PantallaMaps> {
  final _auth = FirebaseAuth.instance;
  List<Marker> myMarker = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(19.4326, -99.1332),
          zoom: 15
        ),
        markers: Set.from(myMarker),
        onTap: _handleTap,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          guardarUbicacion();
        },
        label: const Text("Guardar"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  _handleTap(LatLng tappedPoint){
    print(tappedPoint);
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
        )
      );
    });
  }
  guardarUbicacion() async{
    if(myMarker.isEmpty){
      Fluttertoast.showToast(msg:"Selecciona un punto en el mapa");
    }else{
      LatLng position = myMarker[0].position;
      double latitud = position.latitude;
      double longitud = position.longitude;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user= _auth.currentUser;
      final document = firebaseFirestore
      .collection("usuarios")
      .doc(user!.uid)
      .collection("cookbooks")
      .doc(widget.id_cookbook)
      .collection("platillos")
      .doc(widget.id_platillo);
      await document.set({
        'ubicacion':{
          'latitud':latitud,
          'longitud':longitud
        }
      }, SetOptions(merge: true));
      Fluttertoast.showToast(msg: "Ubicación guardada correctamente!!");
      Navigator.pushAndRemoveUntil(
      (context), 
      MaterialPageRoute(builder: (context)=>PantallaDetallesPlatillo(id_cookbook: widget.id_cookbook, id_platillo: widget.id_platillo)), 
      (route) => false
    );
    }
  }
}