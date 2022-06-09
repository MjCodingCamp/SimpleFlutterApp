import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'main.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  RegistrationPage createState() => RegistrationPage();
}

class RegistrationPage extends State<RegistrationView> {
  bool loaderStatus = false;
  String userName = "";
  String password = "";

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
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            title: const Text("Registration"),
            centerTitle: true
        ),

        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
                children: const [
                  Spacer(),
                  Text("Register Your Self", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  Spacer()
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
                final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userName, password: password);
                final email = userCredential.user?.email.toString();
                changeStatus();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered Successfully ${email ?? ""}")));
                Navigator.pop(context);
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code)));
                changeStatus();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something wrong")));
                changeStatus();
              }
            }, color: Colors.deepOrange , textColor: Colors.white, elevation: 2, height: 50, minWidth: 150,
                child: const Text("Sign-Up", style: TextStyle(fontSize: 24),)
            ),

            const Spacer(),
            Visibility(visible: loaderStatus,child: const SpinKitChasingDots(color: Colors.deepOrange, size: 80),),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}