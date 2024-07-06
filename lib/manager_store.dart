import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:page_manager/entities/state_manager.dart';

abstract class ManagerStore<E> extends ChangeNotifier {
  StateManager _state = StateManager.initial;
  StateManager get state => _state;
  Exception? error;
  final _errorEvent = ValueNotifier<Exception?>(null);
  final _navigationEvent = ValueNotifier<E?>(null);

  set state(StateManager status) {
    try {
      _state = status;
      notifyListeners();
    } catch (e) {
      log(e.runtimeType.toString(), error: e, name: 'ManagerStore');
    }
  }

  void init(Map<String, dynamic> arguments);

  Future<T?> handleTry<T>({
    required Future<T?> Function() call,
    StateManager Function()? onDone,
    StateManager onCatch = StateManager.error,
    void Function(Object? e)? setError,
    required bool Function(Object? e) onWhenRethow,
    bool showDialogError = false,
  }) async {
    try {
      state = StateManager.loading;
      final result = await call();
      state = onDone != null ? onDone() : StateManager.done;
      return result;
    } on Exception catch (e, s) {
      log(
        e.toString(),
        error: e,
        name: 'ManagerStore',
        stackTrace: s,
      );
      if (showDialogError) {
        _emitMessage(e);
      }
      setError != null ? setError(e) : _handleSetError(e);
      if (onCatch != StateManager.error) {
        state = onCatch;
      }
      if (onWhenRethow(e)) {
        rethrow;
      }
      return null;
    }
  }

  void _handleSetError(Exception e) {
    error = e;
    state = StateManager.error;
  }

  void onErrorMessage(void Function(Exception message) listener) =>
      _errorEvent.addListener(() => listener(_errorEvent.value!));

  void onNavigation(void Function(E event) listener) =>
      _navigationEvent.addListener(() => listener(_navigationEvent.value as E));

  void emitNavigation(E event) {
    _navigationEvent.value = event;
  }

  void _emitMessage(Exception erro) {
    _errorEvent.value = erro;
  }

  @override
  void dispose() {
    _errorEvent.dispose();
    _navigationEvent.dispose();
    super.dispose();
  }
}
