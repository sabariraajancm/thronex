import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Saved / Wishlist")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: colors.primary),
            const SizedBox(height: 16),
            Text(
              "No saved items yet",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the ♥ icon on a product to add to your wishlist.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
