import 'package:cookbook_app/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cookbook_app/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //firebase
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final userField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if(value!.isEmpty){
          return("Ingresa el correo electrónico");
        }
      },
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Correo electrónico",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      //validator(){},
      onSaved: (value){
        passwordController.text = value!;
      },
      validator: (value){
        if(value!.isEmpty){
          return("Ingresa la contraseña");
        }
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20,15,10,15),
        hintText: "Contraseña",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
    final loginButton = Material(
      elevation:5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20,15,20,15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          signIn(emailController.text, passwordController.text);
        },
        child: const Text(
          "Login",
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
                    const SizedBox(
                      height: 100,
                      child: Text(
                        "The Cookbook",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "images/logo.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    userField,
                    const Divider(),
                    passwordField,
                    const Divider(),
                    loginButton,
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("No tienes un cuenta? "),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(
                                builder: (context) => RegistrationScreen(),
                              )
                            );
                          },
                          child: const Text(
                            "Registrate",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        ),
      ),
      
    );
  }

  void signIn(String user, String password) async {
    if(_formKey.currentState!.validate()){
      try{
        await _auth
          .signInWithEmailAndPassword(email: user, password: password)
          .then((uid)=>{
            Fluttertoast.showToast(msg: "Login exitoso"),
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context)=>HomeScreen()
              )
            )
          });  
      }on FirebaseAuthException catch (error){
        Fluttertoast.showToast(msg: error.code);
      }
    }
  }
}