import 'package:flutter_bloc/flutter_bloc.dart';

class LoaderEvent {
  bool loaderStatus;
  LoaderEvent(this.loaderStatus);
}
enum LoaderState {
  start, stop, init
}

class LoadersBloc extends Bloc<LoaderEvent, LoaderState>{
  LoadersBloc(): super(LoaderState.init) {
    on<LoaderEvent>((event, emit) {
      if (event.loaderStatus == true) {
        emit(LoaderState.start);
      } else if (event.loaderStatus == false){
        emit(LoaderState.stop);
      }
    });
  }
}