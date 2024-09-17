import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late  FirebaseFirestore db= FirebaseFirestore.instance;
  String name="";
  String email="";
  String password="";
  String mobile="";
  get()
  async{
    String? id=FirebaseAuth.instance.currentUser?.uid;
    var document = await db.collection('users').doc(id).get();
    Map<String,dynamic>? value= document.data();
    setState(() {
      name=value?['Name'];
      email=value?['Email'];
      mobile=value?['Mobile'];
      password=value?['Password'];
    });
  }
  @override
  void initState(){
    get();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start,children: [
        Container(
          height: 270,
            width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/profile.jpg"))),
          child: Center(child: CircleAvatar(
          radius: 70,
              child: Icon(Icons.person,size: 70,))),
            ),
        SizedBox(height: 10,),
        Text(name,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
        SizedBox(height: 5,),
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Icon(Icons.email,color: Colors.blue,),
          SizedBox(width: 5,),
          Text(email,style: TextStyle(fontSize:18,color: Colors.blue),)
        ],),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal:20),
          alignment:Alignment.centerLeft,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mobile Number:"),
              SizedBox(height: 5,),
              Text(mobile),
              Divider(thickness: 2,)
            ],
          ),
        ),SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal:20),
          alignment:Alignment.centerLeft,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Password:"),
              SizedBox(height: 5,),
              Text(password),
              Divider(thickness: 2,)
            ],
          ),
        ),
        SizedBox(height: 15,),
        FilledButton(onPressed:() async{
         await FirebaseAuth.instance.signOut();
         Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(BuildContext context)=> new Signin()),
                 (Route<dynamic>route)=>false);
        },child:Text("Logout"))

          ]),
        );


  }
}