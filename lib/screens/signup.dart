import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _name=TextEditingController();
    TextEditingController _number=TextEditingController();
    TextEditingController _email=TextEditingController();
    TextEditingController _password=TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150),

              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 35
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _name,
                  decoration: InputDecoration(
                      labelText: "Name"
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _number,
                  decoration: InputDecoration(
                      labelText: "Mobile Number"
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _email,
                  decoration: InputDecoration(
                      labelText: "Email"
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _password,
                  decoration: InputDecoration(
                      labelText: "Password"
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: SizedBox(
                  width: 200,
                  child: FilledButton(
                      onPressed: () async {
                        if(_name.text.isEmpty||_number.text.isEmpty||_email.text.isEmpty||_password.text.isEmpty){
                          var snackBar= SnackBar(content:Text('Empty Field'),backgroundColor: Colors.grey,);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        }else{
                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _email.text.toString(),
                              password: _password.text.toString(),
                            );
                            if(credential!=null){
                              insertData(_name.text, _email.text, _number.text, _password.text, credential.user?.uid);
                            }else{
                              var snackBar= SnackBar(content:Text('Null User'),backgroundColor: Colors.grey,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              var snackBar= SnackBar(content:Text('Weak Password'),backgroundColor: Colors.grey,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } else if (e.code == 'email-already-in-use') {
                              var snackBar= SnackBar(content:Text('Email Already Used'),backgroundColor: Colors.grey,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          } catch (e) {
                            var snackBar= SnackBar(content:Text(e.toString()),backgroundColor: Colors.grey,);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);                          }

                        }

                      },
                      child: Text("SIGN UP")
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()))
                  },
                  child: Text(
                    "Already Have an Account? Sign in",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                    ),
                  ),
                ),
              )


            ]),
      ),
    );
  }

  void insertData(String name, email, mobile, password, userid) {
    FirebaseFirestore dp =FirebaseFirestore.instance;
    final user = <String, dynamic>{
      'Name': name,
      'Email': email,
      'Mobile': mobile,
      'Password': password,
      "ID": userid
    };
    dp.collection("users").doc(userid).set(user).onError((e, _) => print("Error writing document:$e"));
    var snackBar= SnackBar(content:Text('Successfully Inserted'),backgroundColor: Colors.grey,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
  }
}