import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapp/Blocs/LoaderBloc/LoaderBloc.dart';
import 'package:flutterapp/Blocs/UserAuthBloc/UserAuthBloc.dart';
import 'package:flutterapp/Blocs/UserAuthBloc/UserAuthEvent.dart';
import 'package:flutterapp/Cubits/InternetCubit.dart';

class RegistrationView extends StatelessWidget {
   RegistrationView({Key? key}) : super(key: key);
   String userName = "";
   String password = "";

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
                  Text("Register Your Self", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
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
              BlocProvider.of<LoadersBloc>(context).add(LoaderEvent(true));
              BlocProvider.of<UserAuthBloc>(context).add(UserSingUp(userName, password));
            }, color: Colors.deepOrange , textColor: Colors.white, elevation: 2, height: 50, minWidth: 150,
                child: const Text("Sign-Up", style: TextStyle(fontSize: 24),)
            ),

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
            SizedBox( height: 0,
              child: BlocListener<InternetCubit, InternetState>(listener: (context, state) {
                if ( state == InternetState.gained ){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Internet Connected!"), backgroundColor: Colors.green)
                  );
                } else if ( state == InternetState.lost ){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Internet Not Connected!"), backgroundColor: Colors.deepOrange)
                  );
                }
              }),
            ),
            SizedBox( height: 0,
              child: BlocListener<UserAuthBloc, UserAuthState>(listener: (context, state) {
                if ( state is UserAuthFail ){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMsg), backgroundColor: Colors.green)
                  );
                  BlocProvider.of<LoadersBloc>(context).add(LoaderEvent(false));
                } else if ( state is UserAuthSuccess ){
                  BlocProvider.of<LoadersBloc>(context).add(LoaderEvent(false));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered Successfully ${state.userEmail}")));
                  Navigator.pop(context);
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
