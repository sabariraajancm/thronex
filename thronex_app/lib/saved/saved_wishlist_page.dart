import 'package:flutter/material.dart';

class SavedWishlistPage extends StatelessWidget {
  const SavedWishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Dummy wishlist items (later will connect to backend)
    final items = [
      {
        "title": "iPhone 13",
        "subtitle": "128 GB • Like New",
        "price": "₹42,999",
      },
      {
        "title": "Samsung A54 Display",
        "subtitle": "Brand New • Original",
        "price": "₹4,999",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Saved Items")),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No saved items yet",
                    style: TextStyle(fontSize: 15, color: colors.secondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.favorite, color: Colors.red),
                    ),
                    title: Text(
                      item["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      item["subtitle"]!,
                      style: TextStyle(color: colors.secondary, fontSize: 12),
                    ),
                    trailing: Text(
                      item["price"]!,
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {
                      // later open product detail
                    },
                  ),
                );
              },
            ),
    );
  }
}
