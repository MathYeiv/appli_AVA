import 'package:flutter/material.dart';

class CustomArtistDisplay extends StatelessWidget {
  final String artistName;
  final VoidCallback onTap;

  const CustomArtistDisplay({
    super.key,
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
        title: Text(artistName),
        onTap: onTap,
      ),
    );
  }
}
