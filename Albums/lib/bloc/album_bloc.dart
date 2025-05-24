import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/album.dart';
import '../models/photo.dart';
import '../services/api_service.dart';

// Events
abstract class AlbumEvent {}

class LoadAlbums extends AlbumEvent {}

class LoadAlbumPhotos extends AlbumEvent {
  final int albumId;
  LoadAlbumPhotos(this.albumId);
}

// States
abstract class AlbumState {}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  final List<Photo> photos;

  AlbumLoaded(this.albums, this.photos);
}

class AlbumError extends AlbumState {
  final String message;

  AlbumError(this.message);
}

// BLoC
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final ApiService apiService;
  List<Album> _currentAlbums = [];

  AlbumBloc(this.apiService) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadAlbumPhotos>(_onLoadAlbumPhotos);
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    try {
      print('Loading albums...');
      emit(AlbumLoading());
      final albums = await apiService.getAlbums();
      _currentAlbums = albums;
      print('Loaded ${albums.length} albums');
      emit(AlbumLoaded(albums, []));
    } catch (e) {
      print('Error loading albums: $e');
      emit(AlbumError(e.toString()));
    }
  }

  Future<void> _onLoadAlbumPhotos(LoadAlbumPhotos event, Emitter<AlbumState> emit) async {
    try {
      print('Loading photos for album ${event.albumId}...');
      emit(AlbumLoading());
      final photos = await apiService.getPhotosByAlbumId(event.albumId);
      print('Loaded ${photos.length} photos for album ${event.albumId}');
      emit(AlbumLoaded(_currentAlbums, photos));
    } catch (e) {
      print('Error loading photos: $e');
      emit(AlbumError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    apiService.dispose();
    return super.close();
  }
} 