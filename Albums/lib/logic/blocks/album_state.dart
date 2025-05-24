import '../../data/models/album_model.dart';
import '../../data/models/photo_model.dart';

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
