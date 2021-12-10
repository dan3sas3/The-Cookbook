import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook_app/homepage.dart';
import 'package:cookbook_app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({ Key? key }) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final usernameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final comfirmPassEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      //validator(){},
      onSaved: (value){
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Correo Electrónico",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator:(value){
        RegExp regex = RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return ("Contraseña necesaria");
        }
        if(!regex.hasMatch(value)){
          return ("La contraseña debe de ser de al menos 6 caracteres");
        }
      },
      onSaved: (value){
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Contraseña",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
    final passwordConfirmField = TextFormField(
      autofocus: false,
      controller: comfirmPassEditingController,
      obscureText: true,
      validator:(value){
        if(comfirmPassEditingController.text != passwordEditingController.text){
          return "Las contraseñas no son iguales";
        }
        return null;
      },
      onSaved: (value){
        comfirmPassEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Confirmar Contraseña",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );        
    final signUpButton = Material(
      elevation:5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20,15,20,15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text(
          "Registrarme!",
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
      body: Center(
        child: SingleChildScrollView(
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
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "images/logo.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    emailField,
                    const Divider(),
                    passwordField,
                    const Divider(),
                    passwordConfirmField,
                    const Divider(),
                    signUpButton
                  ],
                ),
              ),
            )
          ),
        ),
      ),
      
    );
  }
  void signUp(String email, String password) async {
    if(_formKey.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
          postDetailsToFirestore()
        })
        .catchError((e){
          Fluttertoast.showToast(msg: e!.message);
        });
    }
  }

  postDetailsToFirestore() async{
    //llamar a firestore
    //llamar usermodel y mandar valores
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;

    await firebaseFirestore
      .collection("usuarios")
      .doc(user.uid)
      .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Cuenta creada correctamente");
    Navigator.pushAndRemoveUntil(
      (context), 
      MaterialPageRoute(builder: (context)=>HomeScreen()), 
      (route) => false
    );
  }
}
