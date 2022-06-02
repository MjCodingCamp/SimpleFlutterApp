import 'package:flutter/material.dart';

void main() {
  runApp(const FirstApp());
}

class FirstApp extends StatefulWidget {
  const FirstApp({Key? key}) : super(key: key);

  @override
  FirstPage createState() {
    return FirstPage();
  }
}

class FirstPage extends State<FirstApp>{
  String pageTitle = "Welcome to the Flutter";
  Color containerColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
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
                child: const TextField(autocorrect: true,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(hintText: "User Name",
                    labelText: "User Name",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
               Container(
                 height: 55, margin: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                child: const TextField(obscureText: true,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(hintText: "Password",
                    labelText: "Password",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(onPressed: (){
                print("Working on it");
              }, color: Colors.deepOrange ,
                  textColor: Colors.white,
                  elevation: 2, height: 50, minWidth: 150,
                  child: const Text("Login", style: TextStyle(fontSize: 24),)
              )
            ],
          ),
        ),
      ),
    );
  }
}

