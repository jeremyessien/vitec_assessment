import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/routes_repository.dart';
import 'routes_event.dart';
import 'routes_state.dart';

class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  final RoutesRepository repository;
  final int pageSize = 2; 
  Timer? refreshTimer;

  RoutesBloc({required this.repository}) : super(RoutesInitial()) {
    on<LoadInitialRoutesEvent>(onLoadInitialRoutes);
    on<LoadMoreRoutesEvent>(onLoadMoreRoutes);
    on<RefreshRoutesEvent>(onRefreshRoutes);
  }

  @override
  Future<void> close() {
    refreshTimer?.cancel();
    return super.close();
  }

  void startRefreshTimer() {
    refreshTimer?.cancel();
    refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      add(RefreshRoutesEvent());
    });
  }

  Future<void> onLoadInitialRoutes(
    LoadInitialRoutesEvent event,
    Emitter<RoutesState> emit,
  ) async {
    emit(RoutesLoading());
    
    try {
      final routes = await repository.getRoutes();
      final displayedRoutes = routes.take(pageSize).toList();
      
      emit(RoutesLoaded(
        allRoutes: routes,
        displayedRoutes: displayedRoutes,
        hasMoreRoutes: routes.length > pageSize,
      ));
      
      startRefreshTimer();
    } catch (e) {
      emit(RoutesError(e.toString()));
    }
  }

  Future<void> onLoadMoreRoutes(
    LoadMoreRoutesEvent event,
    Emitter<RoutesState> emit,
  ) async {
    if (state is RoutesLoaded) {
      final currentState = state as RoutesLoaded;
      
      emit(RoutesMoreLoading(currentState.displayedRoutes));
      
      try {
        final nextBatchSize = currentState.displayedRoutes.length + pageSize;
        final updatedDisplayedRoutes = currentState.allRoutes
            .take(nextBatchSize)
            .toList();
        
        emit(RoutesLoaded(
          allRoutes: currentState.allRoutes,
          displayedRoutes: updatedDisplayedRoutes,
          hasMoreRoutes: currentState.allRoutes.length > nextBatchSize,
        ));
      } catch (e) {
        emit(RoutesError(e.toString()));
      }
    }
  }

  Future<void> onRefreshRoutes(
    RefreshRoutesEvent event,
    Emitter<RoutesState> emit,
  ) async {
    try {
      final currentDisplayCount = state is RoutesLoaded 
          ? (state as RoutesLoaded).displayedRoutes.length 
          : pageSize;
      
      final routes = await repository.getRoutes(forceRefresh: true);
      final displayedRoutes = routes.take(currentDisplayCount).toList();
      
      emit(RoutesLoaded(
        allRoutes: routes,
        displayedRoutes: displayedRoutes,
        hasMoreRoutes: routes.length > displayedRoutes.length,
      ));
    } catch (e) {
      if (state is! RoutesLoaded) {
        emit(RoutesError(e.toString()));
      }
    }
  }
}