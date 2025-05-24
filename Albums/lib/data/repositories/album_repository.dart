import '../models/album_model.dart';
import '../models/photo_model.dart';
import '../services/api_service.dart';

class AlbumRepository {
  final ApiService _apiService;

  AlbumRepository(this._apiService);

  Future<List<Album>> getAlbums() async {
    try {
      return await _apiService.getAlbums();
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }

  Future<List<Photo>> getPhotos() async {
    try {
      return await _apiService.getPhotos();
    } catch (e) {
      throw Exception('Failed to fetch photos: $e');
    }
  }

  Future<List<Photo>> getPhotosByAlbumId(int albumId) async {
    try {
      final photos = await _apiService.getPhotos();
      return photos.where((photo) => photo.albumId == albumId).toList();
    } catch (e) {
      throw Exception('Failed to fetch photos for album $albumId: $e');
    }
  }

  void dispose() {
    _apiService.dispose();
  }
}
