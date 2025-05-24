import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/album_model.dart';
import '../../data/models/photo_model.dart';
import '../../data/repositories/album_repository.dart';

// Events
abstract class AlbumEvent {}

class LoadAlbums extends AlbumEvent {}

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

// ViewModel
class AlbumViewModel extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository _repository;

  AlbumViewModel(this._repository) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    try {
      emit(AlbumLoading());
      final albums = await _repository.getAlbums();
      final photos = await _repository.getPhotos();
      emit(AlbumLoaded(albums, photos));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  Future<List<Photo>> getPhotosForAlbum(int albumId) async {
    try {
      return await _repository.getPhotosByAlbumId(albumId);
    } catch (e) {
      throw Exception('Failed to get photos for album: $e');
    }
  }
} 