import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo at the top center
            Center(
              child: Image.asset(
                'assets/images/icon.png', // make sure this path is correct
                height: 100,
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "AVA",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "AVA est une application d'assistance conçue pour aider les personnes autistes à mieux gérer les stimulations sonores et lumineuses grâce à des lunettes connectées.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Équipe AVA", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("contact@ava.fr"), // ← update this if needed
            ),
          ],
        ),
      ),
    );
  }
}
