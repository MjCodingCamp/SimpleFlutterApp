import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            title: const Text('Home'),
            centerTitle: true
        ),

        body: Center(
          child: Column(
            children: [ const SizedBox(height: 30,),
              Text("Welcome $title",
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              const Spacer(),
              MaterialButton(onPressed: () {
                Navigator.pop(context);
                },
                  child: const Text('Logout', style: TextStyle(color: Colors.deepOrange, fontSize: 24),)
              ),
              const Spacer() ],
          ),
        ),
      ),
    );
  }
}
