import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/album_bloc.dart';
import '../screens/album_list_screen.dart';
import '../screens/album_detail_screen.dart';
import '../models/album.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AlbumListScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final album = state.extra as Album;
        return BlocProvider.value(
          value: context.read<AlbumBloc>(),
          child: AlbumDetailScreen(album: album),
        );
      },
    ),
  ],
);
