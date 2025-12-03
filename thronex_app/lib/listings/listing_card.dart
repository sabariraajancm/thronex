import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  final String title;
  final String price;
  final String status;
  final String location;
  final IconData imageIcon;

  const ListingCard({
    super.key,
    required this.title,
    required this.price,
    required this.status,
    required this.location,
    required this.imageIcon,
  });

  Color _statusColor(String s) {
    if (s == "Active") return const Color(0xFF22C55E);
    if (s == "Draft") return const Color(0xFFF59E0B);
    return const Color(0xFFE11D48); // sold
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: colors.primary.withOpacity(0.08),
                ),
                child: Icon(imageIcon, size: 34, color: Colors.black87),
              ),
              const SizedBox(width: 14),

              // TEXT SECTION
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
