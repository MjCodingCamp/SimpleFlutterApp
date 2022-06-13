import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutterapp/Bloc/InternetBloc/InternetEvent.dart';
import 'package:flutterapp/Bloc/InternetBloc/InternetState.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();

  InternetBloc() : super( InternetInitState() ) {
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()) );
    on<InternetGainEvent>((event, emit) => emit(InternetGainState()) );
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ){
        print("Mj-4");
        add(InternetGainEvent());
      } else {
        print("Mj-6");
        add(InternetLostEvent());
      }
    });
  }
}