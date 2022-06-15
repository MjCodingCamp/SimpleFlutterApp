import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/Blocs/UserAuthBloc/UserAuthEvent.dart';

import '../LoaderBloc/LoaderBloc.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState>{
  UserAuthBloc(): super(UserAuthInit()){
    on<UserSingIn>((event, emit) async {
      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.userName, password: event.password);
        final userEmail = userCredential.user?.email;
        if (userEmail != null) {
          emit(UserAuthSuccess(userEmail));
        }
      } on FirebaseAuthException catch (e) {
        emit(UserAuthFail(e.code));
      } catch (e) {
        emit(UserAuthFail(e.toString()));
      }
    });
    on<UserSingUp>((event, emit) async {
      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: event.userName, password: event.password);
        final email = userCredential.user?.email.toString();
        emit(UserAuthSuccess(email ?? ""));
      } on FirebaseAuthException catch (e) {
        emit(UserAuthFail(e.code));
      } catch (e) {
        emit(UserAuthFail(e.toString()));
      }
    });
  }
}