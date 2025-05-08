import 'package:flutter/material.dart';

class CustomAlbumDisplay extends StatelessWidget {
  final String albumName;
  final String artistName;
  final VoidCallback onTap;

  const CustomAlbumDisplay({
    super.key,
    required this.albumName,
    required this.artistName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(albumName),
        subtitle: Text(artistName),
        onTap: onTap,
      ),
    );
  }
}
