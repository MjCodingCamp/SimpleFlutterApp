
import 'dart:async';

class AuthBloc {
  final _stateStreamController = StreamController<int>();
  StreamSink<int> get counterSink => _stateStreamController.sink;
  Stream<int> get counterStream => _stateStreamController.stream;
}

enum LoaderStatus {
  turnOn,
  turnOff
}
class LoaderBloc {
  var loaderStatus = false;
  final _stateStreamController = StreamController<bool>();
  StreamSink<bool> get loaderSink => _stateStreamController.sink;
  Stream<bool> get loaderStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<LoaderStatus>();
  StreamSink<LoaderStatus> get loaderEventSink => _eventStreamController.sink;
  Stream<LoaderStatus> get loaderEventStream => _eventStreamController.stream;

  LoaderBloc() {
    loaderEventStream.listen((event) {
      if (event == LoaderStatus.turnOn) {
        loaderStatus = true;
      } else if (event == LoaderStatus.turnOff) {
        loaderStatus = false;
      }
      loaderSink.add(loaderStatus);
    });
  }
}