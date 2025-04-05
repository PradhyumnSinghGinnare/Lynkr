import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkly/components/my_button.dart';
import 'package:linkly/components/my_textfield.dart';
import '../constrained_scaffold/constrained_scaffold.dart';
import '../helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  //register
  void registerUser() async{
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        )
    );

    //make sure passwords match
    if(passwordController.text != confirmPasswordController.text){
      //pop loading circle
      Navigator.pop(context);

      //show error message to user
      displayMessageToUser("Passwords doesn't match", context);
    } else{ //if passwords do match
      //try creating the user
      try{
        //create the user
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

        //create a user document and add to firestore
        createUserDocument(userCredential);

        //pop loading circle
        if(context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch(e){
        //pop loading circle
        Navigator.pop(context);

        //show error message to user
        displayMessageToUser(e.code, context);
      }
    }
  }

  //create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async{
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email':userCredential.user!.email,
        'username':usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 25),

              //app name
              Text(
                "L Y N K R",
                style: TextStyle(
                    fontSize: 20
                ),
              ),

              const SizedBox(height: 50),

              //username textfield
              MyTextfield(hintText: "Username", obscureText: false, controller: usernameController),

              const SizedBox(height: 10),

              //email textfield
              MyTextfield(hintText: "Email", obscureText: false, controller: emailController),

              const SizedBox(height: 10),

              //password textfield
              MyTextfield(hintText: "Password", obscureText: true, controller: passwordController),

              const SizedBox(height: 10),

              //confirm password textfield
              MyTextfield(hintText: "Confirm Password", obscureText: true, controller: confirmPasswordController),

              const SizedBox(height: 25),

              //register button
              MyButton(text: "Register", onTap: registerUser),

              const SizedBox(height: 10),

              //don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary
                  ),),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(" Login here", style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}