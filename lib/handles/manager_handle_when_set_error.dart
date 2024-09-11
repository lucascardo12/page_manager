import 'package:page_manager/entities/state_manager.dart';

abstract interface class ManagerHandleWhenSetError {
  StateManager call(Object? e);
}
