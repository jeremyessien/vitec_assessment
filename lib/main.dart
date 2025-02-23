import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'data/repositories/routes_repository.dart';
import 'data/services/api_service.dart';
import 'presentation/blocs/routes/routes_bloc.dart';
import 'presentation/screens/routes/routes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        cardTheme: CardTheme(
        color: Colors.grey[200],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
       textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.grey[800]), // For headings
        bodyMedium: TextStyle(color: Colors.grey[600]), // For regular text
      ),
      
       progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Colors.blueGrey[300], 
      ),
      iconTheme: IconThemeData(
        color: Colors.grey[700],
      ),
      
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ApiService>(
            create: (context) => ApiService(),
          ),
          RepositoryProvider<FlutterSecureStorage>(
            create: (context) => const FlutterSecureStorage(),
          ),
          RepositoryProvider<RoutesRepository>(
            create: (context) => RoutesRepository(
              apiService: context.read<ApiService>(),
              storage: context.read<FlutterSecureStorage>(),
            ),
          ),
        ],
        child: BlocProvider(
          create: (context) => RoutesBloc(
            repository: context.read<RoutesRepository>(),
          ),
          child: const RoutesScreen(),
        ),
      ),
    );
  }
}