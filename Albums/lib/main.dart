import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'bloc/album_bloc.dart';
import 'services/api_service.dart';
import 'routes/app_router.dart';

void main() {
  final apiService = ApiService(http.Client());
  runApp(
    BlocProvider(
      create: (context) {
        final bloc = AlbumBloc(apiService);
        bloc.add(LoadAlbums());
        return bloc;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Album App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
