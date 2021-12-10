import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook_app/platillo_detalles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class crearReceta extends StatefulWidget {
  final String id_cookbook;
  final String id_platillo;
  crearReceta({Key ? key, required this.id_cookbook, required this.id_platillo}):super(key:key);

  @override
  _crearRecetaState createState() => _crearRecetaState();
}

class _crearRecetaState extends State<crearReceta> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final tiempoEditingController = new TextEditingController();
  final preparacionEditingController = new TextEditingController();
  List<TextEditingController> _ingredientControllers = [];
  List<TextField> _ingredients = [];
  @override
  void dispose(){
    for(final controller in _ingredientControllers){
      controller.dispose();
    }
    super.dispose();
  }
  Widget _addIngredient(){
    return ListTile(
      title: const Text('Clic aquí para añadir Ingrediente +', textAlign: TextAlign.center),
      onTap: (){
        final controller = TextEditingController();
        final field = TextField(
          controller:controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Ingrediente #${_ingredientControllers.length+1}"
          ),
        );
        setState(() {
          _ingredientControllers.add(controller);
          _ingredients.add(field);
        });
      },
    );
  }
  Widget _listView(){
    return ListView.builder(
        itemCount: _ingredients.length,
        itemBuilder: (context, index){
          return Container(
            margin: const EdgeInsets.all(5),
            child: _ingredients[index],
          );
        },
        shrinkWrap: true,
      );
  }

  @override
  Widget build(BuildContext context) {
    final tiempoField = TextFormField(
      autofocus: false,
      controller: tiempoEditingController,
      //validator(){},
      onSaved: (value){
        tiempoEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.alarm_sharp),
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Tiempo de preparación",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
    final preparacionField = TextFormField(
      autofocus: false,
      controller: preparacionEditingController,
      validator:(value){
        if(value!.isEmpty){
          return ("Preparación Necesaria");
        }
      },
      onSaved: (value){
        preparacionEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      minLines: 5,
      maxLines: 50,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.assignment_rounded),
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Preparación",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
    final crearRecetaButton = Material(
      elevation:5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20,15,20,15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          guardarReceta();
        },
        child: const Text(
          "Guardar Receta",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
      body: Column(
        children: [
          const SizedBox(
            height:70,
            child: Text(
              "Nueva Receta",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const Text(
              "Ingredientes:",
              style: TextStyle(
                fontSize: 20
              ),
              textAlign: TextAlign.left,
            ),
          _addIngredient(),
          Expanded(child: _listView()),
          tiempoField,
          const Divider(),
          SizedBox(child: preparacionField, height:150,),
          crearRecetaButton
        ]
      ),   
    );
  }
  guardarReceta() async{
    List<String> ingredientes = [];
    for(var i in _ingredientControllers){
      ingredientes.add(i.text);
    }
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    final document = firebaseFirestore
      .collection("usuarios")
      .doc(user!.uid)
      .collection("cookbooks")
      .doc(widget.id_cookbook)
      .collection("platillos")
      .doc(widget.id_platillo);
    await document.set({
      'receta':{
        'ingredientes':ingredientes,
        'tiempo':tiempoEditingController.text,
        'preparacion':preparacionEditingController.text
      }
    }, SetOptions(merge: true));
    Fluttertoast.showToast(msg: "Receta creada correctamente!");
    Navigator.pushAndRemoveUntil(
      (context), 
      MaterialPageRoute(builder: (context)=>PantallaDetallesPlatillo(id_platillo:widget.id_platillo, id_cookbook:widget.id_cookbook)), 
      (route) => false
    );
  }
}
