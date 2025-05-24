import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/album_bloc.dart';
import '../models/album.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailScreen({
    super.key,
    required this.album,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  @override
  void initState() {
    super.initState();
    print('AlbumDetailScreen initialized for album ${widget.album.id}');
    // Ensure we load photos when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Loading photos for album ${widget.album.id}');
      if (!mounted) return;
      context.read<AlbumBloc>().add(LoadAlbumPhotos(widget.album.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<AlbumBloc, AlbumState>(
        listener: (context, state) {
          print('State changed: $state');
          if (state is AlbumError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          print('Building with state: $state');
          if (state is AlbumLoading) {
            print('Loading state detected');
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumLoaded) {
            final photos = state.photos;
            print('Loaded state detected with ${photos.length} photos');
            
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: photos.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No photos available for this album'),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      final photo = photos[index];
                      print('Building photo item $index: ${photo.title}');
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                photo.thumbnailUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  print('Loading image: ${loadingProgress.expectedTotalBytes}');
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                photo.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            );
          } else if (state is AlbumError) {
            print('Error state detected: ${state.message}');
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No album information available'));
        },
      ),
    );
  }
} 