import 'package:equatable/equatable.dart';

enum NavBarItem { all, progress, completed }

class NavigationState extends Equatable {
  final NavBarItem navBarItem;
  final int index;

  const NavigationState(this.navBarItem, this.index);

  @override
  List<Object> get props => [navBarItem, index];
}
