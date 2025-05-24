import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/photo.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  ApiService(this.client);

  Future<List<Album>> getAlbums() async {
    try {
      print('Fetching albums...');
      final response = await client.get(Uri.parse('$baseUrl/albums'));
      print('Albums response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final albums = jsonData.map((json) => Album.fromJson(json)).toList();
        print('Fetched ${albums.length} albums');
        return albums;
      } else {
        throw Exception('Failed to load albums');
      }
    } catch (e) {
      print('Error fetching albums: $e');
      throw Exception('Failed to load albums: $e');
    }
  }

  Future<List<Photo>> getPhotos() async {
    try {
      print('Fetching all photos...');
      final response = await client.get(Uri.parse('$baseUrl/photos'));
      print('Photos response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final photos = jsonData.map((json) => Photo.fromJson(json)).toList();
        print('Fetched ${photos.length} photos');
        return photos;
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      print('Error fetching photos: $e');
      throw Exception('Failed to load photos: $e');
    }
  }

  Future<List<Photo>> getPhotosByAlbumId(int albumId) async {
    try {
      print('Fetching photos for album $albumId...');
      final response = await client.get(Uri.parse('$baseUrl/albums/$albumId/photos'));
      print('Photos response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final photos = jsonData.map((json) => Photo.fromJson(json)).toList();
        print('Fetched ${photos.length} photos for album $albumId');
        return photos;
      } else {
        throw Exception('Failed to load photos for album $albumId');
      }
    } catch (e) {
      print('Error fetching photos for album $albumId: $e');
      throw Exception('Failed to load photos for album $albumId: $e');
    }
  }

  void dispose() {
    client.close();
  }
} 