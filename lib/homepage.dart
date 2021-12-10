import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook_app/model/user_model.dart';
import 'package:cookbook_app/model/cookbook_model.dart';
import 'package:cookbook_app/nuevo_cookbook.dart';
import 'package:cookbook_app/platillos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookbook_app/sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List resultados = <Map>[];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
      .collection("usuarios")
      .doc(user!.uid)
      .collection("cookbooks")
      .get()
      .then((querySnapshot){
        querySnapshot.docs.forEach((result) {
          CookBookModel cookbookModel =  CookBookModel.fromDocument(result);
          resultados.add({
              'cid':cookbookModel.cid,
              'nombre_cookbook':cookbookModel.nombre_cookbook,
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
        title: const Text("Mis Cookbooks")
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column (
          children: [
             for(var cookbook in resultados) Card(
              child: ListTile(
                leading: Image.network(
                  cookbook['imagen_portada'],
                  height: 100,
                  width: 100,
                ), 
                title: Text(cookbook['nombre_cookbook']),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaPlatillos(id_cookbook: cookbook['cid'],)
                    )
                  );
                },
              ),
            ),
            ActionChip(
                  label: const Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(
            builder: (context) => crearCookbook(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
