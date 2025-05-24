// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:album_list/data/repositories/album_repository.dart';
import 'package:album_list/data/services/api_service.dart';
import 'package:album_list/logic/blocks/album_bloc.dart';
import 'package:album_list/presentation/screens/album_list_screen.dart';
import 'package:album_list/main.dart';

void main() {
  late http.Client httpClient;
  late ApiService apiService;
  late AlbumRepository albumRepository;
  late AlbumBloc albumBloc;

  setUp(() {
    httpClient = http.Client();
    apiService = ApiService(httpClient);
    albumRepository = AlbumRepository(apiService);
    albumBloc = AlbumBloc(albumRepository);
  });

  tearDown(() {
    albumBloc.close();
    albumRepository.dispose();
    httpClient.close();
  });

  testWidgets('Album app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => albumBloc,
          child: const AlbumListScreen(),
        ),
      ),
    );

    // Verify that the app shows loading indicator initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the loading to complete
    await tester.pumpAndSettle();

    // Verify that the app shows the album list
    expect(find.byType(ListView), findsOneWidget);
  });
}
