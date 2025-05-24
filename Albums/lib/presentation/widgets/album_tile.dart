import 'package:flutter/material.dart';
import '../../data/models/album_model.dart';
import '../../data/models/photo_model.dart';

class AlbumTile extends StatelessWidget {
  final Album album;
  final Photo? photo;
  final VoidCallback onTap;

  const AlbumTile({
    Key? key,
    required this.album,
    this.photo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: photo != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            photo!.thumbnailUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
          ),
        )
            : Icon(Icons.photo_album, size: 50),
        title: Text(
          album.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      ),
    );
  }
}
