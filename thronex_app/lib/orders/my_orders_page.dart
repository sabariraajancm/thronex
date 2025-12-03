import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Dummy order list
    final orders = [
      {
        "title": "iPhone 13",
        "subtitle": "128 GB • Like New",
        "status": "Delivered",
        "date": "12 Nov 2025",
        "price": "₹42,999",
      },
      {
        "title": "Samsung A54 Display",
        "subtitle": "Brand New Spare Part",
        "status": "Out for Delivery",
        "date": "10 Nov 2025",
        "price": "₹4,999",
      },
      {
        "title": "OnePlus 9R Back Glass",
        "subtitle": "Black • Original",
        "status": "Pending Confirmation",
        "date": "09 Nov 2025",
        "price": "₹899",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No orders placed yet",
                    style: TextStyle(fontSize: 15, color: colors.secondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final item = orders[index];
                return Card(
                  child: ListTile(
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.black87,
                      ),
                    ),
                    title: Text(
                      item["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["subtitle"]!,
                          style: TextStyle(
                            color: colors.secondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: _statusColor(item["status"]!),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item["status"]!,
                              style: TextStyle(
                                fontSize: 12,
                                color: _statusColor(item["status"]!),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      item["price"]!,
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {
                      // Later: Open detailed order view
                    },
                  ),
                );
              },
            ),
    );
  }

  Color _statusColor(String status) {
    if (status == "Delivered") return const Color(0xFF22C55E);
    if (status == "Out for Delivery") return const Color(0xFFEAB308);
    return const Color(0xFFEF4444); // Pending / Cancelled
  }
}
