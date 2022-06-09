import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'HomePage.dart';
import 'RegPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  FirstState createState() => FirstState();
}

class FirstState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstApp(),
    );
  }
}


class FirstApp extends StatefulWidget {
  const FirstApp({Key? key}) : super(key: key);

  @override
  FirstPage createState() =>  FirstPage();
}

class FirstPage extends State<FirstApp>{
  String pageTitle = "Welcome to the Flutter";
  Color containerColor = Colors.white;
  String userName = "";
  String password = "";
  bool loaderStatus = false;
  void changeStatus(){
    setState((){
      if (loaderStatus) {
        loaderStatus = false;
      } else {
        loaderStatus = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: containerColor,
          appBar: AppBar(
              backgroundColor: Colors.deepOrange,
              title: const Text("First App"),
              centerTitle: true
          ),

          body: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                  children: [
                    const Spacer(),
                    Text(pageTitle, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                    const Spacer()
                  ]
              ),
              const SizedBox(height: 80),

              Container(
                height: 55, margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child:  TextField(autocorrect: true,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: const InputDecoration(hintText: "User Name",
                    labelText: "User Name",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (textValue) {
                  userName = textValue;
                  },
                ),
              ),
               Container(
                 height: 55, margin: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                child:  TextField(obscureText: true,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: const InputDecoration(hintText: "Password",
                    labelText: "Password",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                  password = value;
                  },
                ),
              ),

              const SizedBox(height: 20),
              MaterialButton(onPressed: () async {
                changeStatus();
                try {
                  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: userName, password: password);
                  final userEmail = userCredential.user?.email;
                  if (userEmail != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successful")));
                    changeStatus();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(title: userEmail,)));
                  }

                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code)));
                  changeStatus();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something wrong")));
                  changeStatus();
                }
              }, color: Colors.deepOrange , textColor: Colors.white, elevation: 2, height: 50, minWidth: 150,
                  child: const Text("Login", style: TextStyle(fontSize: 24),)
              ),

              const Spacer(),
              Visibility(visible: loaderStatus,child: const SpinKitChasingDots(color: Colors.deepOrange, size: 80),),
              const Spacer(),

              MaterialButton(onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationView()));
              },  textColor: Colors.deepOrange,
                  child: const Text("SignUp", style: TextStyle(fontSize: 20),)
              )
            ],
          ),
        ),
    );
  }
}
