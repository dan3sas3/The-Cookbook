import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook_app/platillos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class crearPlatillo extends StatefulWidget {
  final String id_cookbook;
  crearPlatillo({Key ? key, required this.id_cookbook}):super(key:key);

  @override
  _crearPlatilloState createState() => _crearPlatilloState();
}

class _crearPlatilloState extends State<crearPlatillo> {
  final _auth  =FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final nombrePlatilloController = new TextEditingController();
  final nombreRestauranteController = new TextEditingController();
  final precioController = new TextEditingController();
  final telController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? imagenSeleccionada;
  
  void _abrirGaleria(BuildContext context) async{
    final imagen = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imagenSeleccionada = imagen;
    });
    Navigator.pop(context);
  }
  void _tomarFoto(BuildContext context) async{
    final imagen = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imagenSeleccionada = imagen;
    });
    Navigator.pop(context);
  }
  void _imagenDefault(BuildContext context) async{
    setState(() {
      imagenSeleccionada = null;
    });
    Navigator.pop(context);
  }

  Widget bottomSheet(){
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20
      ),
      child: Column(
        children: <Widget>[
          const Text(
           "Escoger foto de portada",
            style: TextStyle(
              fontSize: 20
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: (){
                  _tomarFoto(context);
                }, 
                icon: const Icon(Icons.camera), 
                label: const Text("Camera")
              ),
              TextButton.icon(
                onPressed: (){
                  _abrirGaleria(context);
                }, 
                icon: const Icon(Icons.add_photo_alternate), 
                label: const Text("Carrete")
              ),
              TextButton.icon(
                onPressed: (){
                  _imagenDefault(context);
                }, 
                icon: const Icon(Icons.image), 
                label: const Text("Default")
              )
            ],
          )
        ],
      ),
    );
  }

  Widget imagenPortada(){
    return Stack(
      children: <Widget>[
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: const  BorderRadius.all(Radius.circular(8.0)),
                child: imagenSeleccionada==null
                  ? Image.asset('images/defaultImage.jpg')
                  : Image.file(File(imagenSeleccionada!.path))
              )
            ],
          )
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child:InkWell(
            onTap: (){
              showModalBottomSheet(
                context: context, 
                builder: ((builder)=>bottomSheet())
              );
            },
            child: const Icon(Icons.camera_alt, color: Colors.blue, size:20)
          )
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      autofocus: false,
      controller: nombrePlatilloController,
      onSaved: (value){
        nombrePlatilloController.text = value!;
      },
      validator: (value){
        if(value!.isEmpty){
          return ("Nombre de platillo necesario");
        }
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    );
    final restaurantField = TextFormField(
      autofocus: false,
      controller: nombreRestauranteController,
      onSaved: (value){
        nombreRestauranteController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Nombre Restaurante",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    );
    final precioField = TextFormField(
      autofocus: false,
      controller: precioController,
      onSaved: (value){
        precioController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Precio del platillo",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    );
      final telefonoField = TextFormField(
      autofocus: false,
      controller: telController,
      onSaved: (value){
        telController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Telefono del restaurante",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    );
    final newPlatilloButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20,15,20,15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          crearColeccionPlatillo();
        },
        child: const Text(
          "Crear Nuevo Platillo",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child:Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 70,
                    child: Text(
                      "Nuevo Platillo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  
                  const SizedBox(
                    height: 25,
                    child: Text(
                      "Nombre del Platillo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ),
                  nameField,
                  const Divider(),
                  const SizedBox(
                    height: 50,
                    child: Text(
                      "Escoge una portada para este platillo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ),
                  imagenPortada(),
                  const Divider(),
                  const SizedBox(
                    height: 50,
                    child: Text(
                      "Añadir info. de restaurante relacionado al platillo (opcional)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ),
                  restaurantField,
                  Divider(),
                  precioField,
                  Divider(),
                  telefonoField,
                  Divider(),
                  newPlatilloButton,
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
  Future<String> uploadImage(File _image) async{
  FirebaseStorage storage = FirebaseStorage.instance;
  String fileName = _image.path.split('/').last;
  Reference storageReference = storage.ref().child('portadas_platillos/$fileName');
  try{
     await storageReference.putFile(_image);
     print("Archivo Cargado");
     String returnURL="";
     await storageReference.getDownloadURL().then((fileURL){
       returnURL = fileURL;
     });
     return returnURL;
  }on FirebaseException catch (e){
    Fluttertoast.showToast(msg: e.code);
    return "Error";
  }
  
  }
  crearColeccionPlatillo() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    String imageURL;
    if(imagenSeleccionada==null){
      imageURL = 'https://firebasestorage.googleapis.com/v0/b/cookbook-6a4c4.appspot.com/o/portadas_cookbooks%2FdefaultImage.jpg?alt=media&token=07e9390f-bb2d-4945-bec5-1c3fd2ea98f8';
    }else{
      imageURL = await uploadImage(File(imagenSeleccionada!.path));
    }
    final document = firebaseFirestore
      .collection("usuarios")
      .doc(user!.uid)
      .collection("cookbooks")
      .doc(widget.id_cookbook)
      .collection("platillos")
      .doc();
      await document.set({
        'pid':document.id,
        'nombre_platillo':nombrePlatilloController.text,
        'imagen_portada':imageURL,
        'restaurante':nombreRestauranteController.text,
        'telefono_restaurante':telController.text,
        'precio':precioController.text
      });
    /*await firebaseFirestore
      .collection("usuarios")
      .doc(user!.uid)
      .collection("cookbooks")
      .add({
        'nombre_cookbook':nombreCookbookController.text,
        'imagen_portada':imageURL
      });*/
    Fluttertoast.showToast(msg: "Platillo creado correctamente!!");
    Navigator.pushAndRemoveUntil(
      (context), 
      MaterialPageRoute(builder: (context)=>PantallaPlatillos(id_cookbook: widget.id_cookbook)), 
      (route) => false
    );
  }
}