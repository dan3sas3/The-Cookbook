import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class VerMaps extends StatefulWidget {
  final double latitud;
  final double longitud;
  final String nombreRestaurante;
  VerMaps({Key ? key, required this.latitud, required this.longitud, required this.nombreRestaurante})
    :super(key:key);

  @override
  _VerMapsState createState() => _VerMapsState();
}

class _VerMapsState extends State<VerMaps> {

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller){
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("id1"),
          position: LatLng(widget.latitud, widget.longitud),
          infoWindow: InfoWindow(
            title: widget.nombreRestaurante,
            snippet: "Restaurante"
          )
        )
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitud, widget.longitud),
          zoom: 15
        ),
        markers: _markers,
      ),
    );
  }
}