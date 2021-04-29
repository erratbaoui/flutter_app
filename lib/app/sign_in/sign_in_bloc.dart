import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<bool> _streamController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _streamController.stream;

  void dispose() {
    _streamController.close();

  }

  void _setIsLoading(bool isLoading) => _streamController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signIn) async {
    try {
      _setIsLoading(true);
      return await signIn();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
