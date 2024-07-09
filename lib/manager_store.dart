import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:page_manager/entities/state_manager.dart';
import 'package:page_manager/handles/manager_handle_when_get_rethrow.dart';

abstract class ManagerStore<E> extends ChangeNotifier {
  StateManager _state = StateManager.initial;
  StateManager get state => _state;
  Object? error;
  final _errorEvent = ValueNotifier<Object?>(null);
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
    } catch (e, s) {
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
      if (GetIt.I.isRegistered<ManagerHandleWhenGetRethrow>()) {
        if (GetIt.I<ManagerHandleWhenGetRethrow>().call(e)) {
          rethrow;
        }
      }
      return null;
    }
  }

  void _handleSetError(Object e) {
    error = e;
    state = StateManager.error;
  }

  void onErrorMessage(void Function(Object event) listener) =>
      _errorEvent.addListener(() => listener(_errorEvent.value!));

  void onNavigation(void Function(E event) listener) =>
      _navigationEvent.addListener(() => listener(_navigationEvent.value as E));

  void emitNavigation(E event) {
    _navigationEvent.value = event;
  }

  void _emitMessage(Object erro) {
    _errorEvent.value = erro;
  }

  @override
  void dispose() {
    _errorEvent.dispose();
    _navigationEvent.dispose();
    super.dispose();
  }
}
