import 'dart:developer';

import 'package:aliftech_test/models/nav_bar_item.dart';
import 'package:bloc/bloc.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(NavBarItem.all, 0));

  void getNavBarItem(NavBarItem navBarItem) {
    log(navBarItem.toString());
    switch (navBarItem) {

      case NavBarItem.all:
        emit(NavigationState(NavBarItem.all, 0));
        break;
      case NavBarItem.progress:
        emit(NavigationState(NavBarItem.progress, 1));
        break;
      case NavBarItem.completed:
        emit(NavigationState(NavBarItem.completed, 2));
        break;
    }
  }
}