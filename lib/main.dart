import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapp/AuthBlocs.dart';
import 'HomePage.dart';
import 'RegPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  FirstPage(),
    );
  }

}

class FirstPage extends StatelessWidget {
  FirstPage({Key? key}) : super(key: key);

  String pageTitle = "Welcome to the Flutter";
  Color containerColor = Colors.white;
  String userName = "";
  String password = "";
  LoaderBloc loaderBloc = LoaderBloc();

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
                loaderBloc.loaderEventSink.add(LoaderStatus.turnOn);
                try {
                  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: userName, password: password);
                  final userEmail = userCredential.user?.email;
                  if (userEmail != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successful")));
                    loaderBloc.loaderEventSink.add(LoaderStatus.turnOff);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title: userEmail)));
                  }

                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code)));
                  loaderBloc.loaderEventSink.add(LoaderStatus.turnOff);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something wrong")));
                  loaderBloc.loaderEventSink.add(LoaderStatus.turnOff);
                }
              }, color: Colors.deepOrange , textColor: Colors.white, elevation: 2, height: 50, minWidth: 150,
                  child: const Text("Login", style: TextStyle(fontSize: 24),)
              ),

              const Spacer(),
              StreamBuilder<bool>(
                  stream: loaderBloc.loaderStream,
                  builder: (context, snapshot) {
                    return
                      Visibility(visible: snapshot.data ?? false,child: const SpinKitChasingDots(color: Colors.deepOrange, size: 80));
                  }
              ),
              const Spacer(),

              MaterialButton(onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationView()));
              },  textColor: Colors.deepOrange,
                  child: const Text("SignUp", style: TextStyle(fontSize: 20),)
              )
            ],
          ),
        ),
    );
  }
}
