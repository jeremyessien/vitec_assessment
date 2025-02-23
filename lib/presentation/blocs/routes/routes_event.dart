import 'package:equatable/equatable.dart';

abstract class RoutesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadInitialRoutesEvent extends RoutesEvent {}

class LoadMoreRoutesEvent extends RoutesEvent {}

class RefreshRoutesEvent extends RoutesEvent {}
