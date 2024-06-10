library view_model;

import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class AbstractViewModel<SMT> {
  //SMT - StateModelType
  AbstractViewModel(SMT defaultModelState) {
    this.currentState = defaultModelState;
  }

  late SMT currentState;
  final StreamController<SMT> _state = StreamController<SMT>.broadcast();

  Stream<SMT> get state => _state.stream;

  void getState();

  SMT getCurrentState() {
    return currentState;
  }

  void dispose() {
    _state.close();
  }

  @protected
  updateState(SMT newState) {
    currentState = newState;
    if (!_state.isClosed) {
      _state.sink.add(currentState);
    }
  }
}

