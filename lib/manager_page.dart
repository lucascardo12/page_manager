import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:page_manager/manager_store.dart';

abstract class ManagerPage<C extends ManagerStore, T extends StatefulWidget>
    extends State<T> {
  final C ct = GetIt.I.get();

  @override
  void initState() {
    _initStore(ct);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ct.onErrorMessage(_listenerErroMessage);
        final arguments = ModalRoute.of(context)?.settings.arguments;
        ct.init(
          arguments is Map ? Map<String, dynamic>.from(arguments) : {},
        );
      },
    );
    super.initState();
  }

  final _list = <Listenable>[];

  void _initStore(ManagerStore store) {
    if (_list.contains(store)) {
      return;
    }
    _list.add(store);
    store.addListener(_listener);
  }

  void _listener() {
    setState(() {});
  }

  void _listenerErroMessage(Exception e) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Erro'),
          content: Text(e.toString().replaceFirst('Exception:', '')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var element in _list) {
      element.removeListener(_listener);
    }

    ct.dispose();
    super.dispose();
  }
}
