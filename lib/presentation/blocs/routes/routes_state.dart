import 'package:equatable/equatable.dart';
import '../../../data/models/route_model.dart';

abstract class RoutesState extends Equatable {
  const RoutesState();

  @override
  List<Object> get props => [];
}

class RoutesInitial extends RoutesState {}

class RoutesLoading extends RoutesState {}

class RoutesMoreLoading extends RoutesState {
  final List<RouteModel> currentRoutes;

  const RoutesMoreLoading(this.currentRoutes);

  @override
  List<Object> get props => [currentRoutes];
}

class RoutesLoaded extends RoutesState {
  final List<RouteModel> allRoutes;
  final List<RouteModel> displayedRoutes;
  final bool hasMoreRoutes;

  const RoutesLoaded({
    required this.allRoutes,
    required this.displayedRoutes,
    required this.hasMoreRoutes,
  });

  @override
  List<Object> get props => [allRoutes, displayedRoutes, hasMoreRoutes];
}

class RoutesError extends RoutesState {
  final String message;

  const RoutesError(this.message);

  @override
  List<Object> get props => [message];
}
