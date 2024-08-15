import 'package:chitchatapp/screens/dashboard.dart';
import 'package:chitchatapp/screens/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../brainpart/logincontroller.dart';


class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => LoginScreen();
}

class LoginScreen extends State<Loginscreen> {
  bool isLoading = false;

  bool obscure = true;
  void iconChang() {
    if (obscure == true) {
      obscure = false;
    } else {
      obscure = true;
    }
    setState(() {});
  }

  var userForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: userForm,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                height: 150,
                  'assets/chatapplogo.jpeg'),
              SizedBox(height: 15,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                controller: email,
                autocorrect: true,
                enableSuggestions: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Email please',
                    suffixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0))),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.visiblePassword,
                controller: password,
                obscureText: obscure,
                enableSuggestions: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Email please',
                    suffixIcon: InkWell(
                        onTap: () {
                          iconChang();
                        },
                        child: obscure
                            ? const Icon(Icons.remove_red_eye)
                            : const Icon(Icons.remove_red_eye_sharp)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0))),
              ),
              const SizedBox(height: 5.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){},
                      child: const Text('Forget Password',style: TextStyle(color: Colors.grey,fontSize: 15.0),))

                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async{
                    if (userForm.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                    await  LoginController.userLogin(email: email.text, password: password.text, context: context);
                      isLoading = false;
                      setState(() {

                      });
                      email.clear();
                      password.clear();


                    }
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: isLoading? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white,),
                  ): const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You dont have an account yet?',style: TextStyle(color: Colors.grey,fontSize:
                  14.0),),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return SignUpScreen();
                    }));

                  }, child: const Text('Sign Up',style: TextStyle(color: Colors.blue),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
