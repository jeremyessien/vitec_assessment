import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/routes/routes_bloc.dart';
import '../../blocs/routes/routes_event.dart';
import '../../blocs/routes/routes_state.dart';
import 'widgets/route_card.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RoutesBloc>().add(LoadInitialRoutesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        title: const Text(
          'Explore routes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<RoutesBloc, RoutesState>(
            builder: (context, state) {
              if (state is RoutesInitial || state is RoutesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RoutesLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Routes ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            TextSpan(
                              text: 'nearby',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff26a69a),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Routes list
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.displayedRoutes.length,
                        itemBuilder: (context, index) {
                          final route = state.displayedRoutes[index];
                          return RouteCard(route: route);
                        },
                      ),
                      if (state.hasMoreRoutes)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<RoutesBloc>()
                                    .add(LoadMoreRoutesEvent());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                                side: BorderSide(color: Colors.blue.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                              ),
                              child: const Text('Load More'),
                            ),
                          ),
                        ),

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Favourite ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            TextSpan(
                              text: 'tours',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff26a69a),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (state.displayedRoutes.isNotEmpty)
                        RouteCard(route: state.displayedRoutes.first),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              } else if (state is RoutesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong please try again',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<RoutesBloc>()
                              .add(LoadInitialRoutesEvent());
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: const Icon(
          Icons.language,
          color: Color(0xff26a69a),
          size: 28,
        ),
      ),
    );
  }
}
