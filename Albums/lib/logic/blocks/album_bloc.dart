import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/album_repository.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository repository;

  AlbumBloc(this.repository) : super(AlbumInitial()) {
    on<LoadAlbums>((event, emit) async {
      await _onLoadAlbums(event, emit);
    });
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    try {
      emit(AlbumLoading());
      final albums = await repository.getAlbums();
      final photos = await repository.getPhotos();
      emit(AlbumLoaded(albums, photos));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}
