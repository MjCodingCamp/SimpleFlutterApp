import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapp/Model/Users.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class HomeView extends StatefulWidget {
  String title;
  HomeView(this.title, {Key? key}) : super(key: key);

  @override
  HomePage createState() {
    return HomePage(title);
  }
}

class HomePage extends State<HomeView> {
  HomePage(this.title);
  String title = "";
  Users? users;

  @override
  void initState(){
    super.initState();
    getUsersData();
  }
  Future<void> getUsersData() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    final data = jsonDecode(response.body);
    final model = Users.fromJson(data);
    users = model;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          actions: [
            MaterialButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp()));
            },
                child: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 14),)
            ),
          ],
          backgroundColor: Colors.deepOrange,
          title: const Text('Home'),
          centerTitle: true
      ),

      body: ListView.builder(
          itemCount: users?.data?.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("${users?.data?[index].email}",
                style: const TextStyle(fontSize: 20.0),
              ),
              leading: SizedBox(
                  height: 100,
                  width: 60,
                  child: Image
                      .network("${users?.data?[index].avatar}")

              ),
            );
          }
      ),

    );
  }

}


// class HomePage extends StatelessWidget {
//   HomePage({Key? key, required this.title}) : super(key: key);
//   String title;
//
//   Future getUsersData() async {
//     final response = await http.get(Uri.https('https://reqres.in/api', 'users?page=2'));
//     final data = jsonDecode(response.body);
//     print(data);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }
