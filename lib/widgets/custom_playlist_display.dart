import 'package:flutter/material.dart';

class CustomPlaylistDisplay extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const CustomPlaylistDisplay({
    super.key,
    required this.title,
    required this.subtitle,
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
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
