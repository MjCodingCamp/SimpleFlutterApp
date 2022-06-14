import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum InternetState {
  initial, lost, gained
}

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _streamSubscription;

  InternetCubit(): super(InternetState.initial){
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi) {
        emit(InternetState.gained);
      } else {
        emit(InternetState.lost);
      }
    });
  }

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    super.close();
  }
}