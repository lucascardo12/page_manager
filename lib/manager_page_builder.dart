import 'package:flutter/material.dart';
import 'package:page_manager/entities/state_manager.dart';

class ManagerPageBuilder extends StatelessWidget {
  final StateManager state;
  final Widget Function() pageDone;
  final Widget Function() pageDisconnected;
  final Widget Function() pageInitial;
  final Widget Function() pageLoading;
  final Widget Function() pageLoggedOut;
  final Widget Function() pageMaintenance;
  final Widget Function(Object? error) pageError;
  final Object? error;
  final bool drawerEnableOpenDragGesture;
  final bool? resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final Widget? drawer;
  final bool safeAreaTop;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  const ManagerPageBuilder({
    super.key,
    required this.state,
    required this.pageDone,
    required this.error,
    required this.pageInitial,
    required this.pageError,
    required this.pageDisconnected,
    required this.pageLoading,
    required this.pageLoggedOut,
    required this.pageMaintenance,
    this.appBar,
    this.drawerEnableOpenDragGesture = true,
    this.resizeToAvoidBottomInset,
    this.backgroundColor,
    this.drawer,
    this.safeAreaTop = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: SafeArea(
        top: safeAreaTop,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: switch (state) {
            StateManager.done => pageDone(),
            StateManager.loading => pageLoading(),
            StateManager.error => pageError(error),
            StateManager.disconnected => pageDisconnected(),
            StateManager.initial => pageInitial(),
            StateManager.loggedOut => pageLoggedOut(),
            StateManager.maintenance => pageMaintenance()
          },
        ),
      ),
    );
  }
}
