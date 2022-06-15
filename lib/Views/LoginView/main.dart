import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapp/Blocs/UserAuthBloc/UserAuthBloc.dart';
import 'package:flutterapp/Blocs/UserAuthBloc/UserAuthEvent.dart';
import 'package:flutterapp/Cubits/InternetCubit.dart';
import '../../Blocs/LoaderBloc/LoaderBloc.dart';
import '../HomeView/HomePage.dart';
import '../RegistrationView/RegPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(create: (context) => InternetCubit(),
    //   child: BlocProvider(create: (context) => UserAuthBloc(),
    //     child: BlocProvider(create: (context) => LoadersBloc(),
    //       child: MaterialApp (
    //           home:  FirstPage()
    //       ),
    //     ),
    //   ),
    // );

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => InternetCubit()),
          BlocProvider(create: (context) => LoadersBloc()),
          BlocProvider(create: (context) => UserAuthBloc())
        ],
        child: MaterialApp (
          home:  FirstPage(),
        )
    );
  }
}

class FirstPage extends StatelessWidget {
  FirstPage({Key? key}) : super(key: key);

  String pageTitle = "Welcome to the Flutter";
  Color containerColor = Colors.white;
  String userName = "";
  String password = "";

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
                BlocProvider.of<LoadersBloc>(context).add(LoaderEvent(true));
                BlocProvider.of<UserAuthBloc>(context).add(UserSingIn(userName, password));
              }, color: Colors.deepOrange , textColor: Colors.white, elevation: 2, height: 50, minWidth: 150,
                  child: const Text("Login", style: TextStyle(fontSize: 24))
              ),

              BlocConsumer<UserAuthBloc, UserAuthState>(builder: (context, state) {
                return Container(height: 0);
              }, listener: (context, state) {
                if (state is UserAuthFail) {
                  BlocProvider.of<LoadersBloc>(context).add(LoaderEvent(false));
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMsg))
                  );
                } else if (state is UserAuthSuccess){
                  BlocProvider.of<LoadersBloc>(context).add(LoaderEvent(false));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Successful"))
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeView(state.userEmail)));
                } else {
                  BlocProvider.of<LoadersBloc>(context).add(LoaderEvent(false));
                }
              }),
              const Spacer(),
              BlocBuilder<LoadersBloc, LoaderState>(builder: (context, state) {
                if (state == LoaderState.start) {
                  return
                    const Visibility(visible: true, child: SpinKitChasingDots(color: Colors.deepOrange, size: 80));
                } else {
                  return
                    const Visibility(visible: false, child: SpinKitChasingDots(color: Colors.deepOrange, size: 80));
                }
              }),
              const Spacer(),
              const Spacer(),
              BlocConsumer<InternetCubit, InternetState>(builder: (context, state) {
                if (state == InternetState.gained || state == InternetState.initial) {
                  return MaterialButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute( builder: (context) => RegistrationView()
                    ));
                  },  textColor: Colors.deepOrange,
                      child: const Text("SignUp", style: TextStyle(fontSize: 20),)
                  );
                } else {
                  return Container(height: 0);
                }
              }, listener: (context, state) {
                if (state == InternetState.gained) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Internet connected!",
                          style: TextStyle(fontSize: 14, color: Colors.white) ), backgroundColor: Colors.green,));
                } else if (state == InternetState.lost) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Internet not connected!",
                          style: TextStyle(fontSize: 14, color: Colors.white) ), backgroundColor: Colors.deepOrange,));
                }
              }),
            ],
          ),
        ),
    );
  }
}
