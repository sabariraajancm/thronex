import 'package:flutter/material.dart';
import 'package:thronex_app/listings/my_listings_page.dart';
import 'package:thronex_app/profile/edit_profile_page.dart';
import 'package:thronex_app/orders/my_orders_page.dart';

class SellerCenterPage extends StatelessWidget {
  const SellerCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text("Seller Center"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // future: open seller FAQs / help
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // VERIFICATION + SUMMARY BANNER
            // ------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B2EFF), Color(0xFF9C6BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Seller Performance Overview",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Get more visibility by keeping listings active and responding quickly to chats.",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 16,
                                color: Color(0xFF22C55E),
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Verification pending – set up later",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // KPI SNAPSHOT ROW
            // ------------------------------------------------
            Row(
              children: const [
                Expanded(
                  child: _KpiCard(
                    label: "Active listings",
                    value: "6",
                    chip: "Live",
                    icon: Icons.phone_android,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _KpiCard(
                    label: "Last 7 days views",
                    value: "184",
                    chip: "Organic",
                    icon: Icons.visibility_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(
                  child: _KpiCard(
                    label: "Chats received",
                    value: "23",
                    chip: "Leads",
                    icon: Icons.chat_bubble_outline,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _KpiCard(
                    label: "Conversion rate",
                    value: "8.4%",
                    chip: "Est.",
                    icon: Icons.trending_up,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ------------------------------------------------
            // QUICK ACTIONS GRID
            // ------------------------------------------------
            const Text(
              "Quick actions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickActionTile(
                  icon: Icons.add_circle_outline,
                  label: "Create listing",
                  onTap: () {
                    // future: go direct to "create listing" flow
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Listing creation flow coming soon."),
                      ),
                    );
                  },
                ),
                _QuickActionTile(
                  icon: Icons.list_alt_outlined,
                  label: "My listings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyListingsPage()),
                    );
                  },
                ),
                _QuickActionTile(
                  icon: Icons.shopping_bag_outlined,
                  label: "Orders",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                    );
                  },
                ),
                _QuickActionTile(
                  icon: Icons.person_outline,
                  label: "Seller profile",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ------------------------------------------------
            // RECENT LISTINGS (STATIC DUMMY DATA)
            // ------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Recent listings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B2EFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const _ListingRowCard(
              title: "iPhone 13 • 128 GB",
              statusLabel: "Live",
              statusColor: Color(0xFF22C55E),
              views: 56,
              chats: 8,
              updated: "Updated 2 hrs ago",
            ),
            const _ListingRowCard(
              title: "Samsung S21 FE",
              statusLabel: "Paused",
              statusColor: Color(0xFFF59E0B),
              views: 32,
              chats: 3,
              updated: "Updated yesterday",
            ),
            const _ListingRowCard(
              title: "OnePlus Nord CE",
              statusLabel: "Draft",
              statusColor: Color(0xFF9CA3AF),
              views: 0,
              chats: 0,
              updated: "Not published",
            ),

            const SizedBox(height: 24),

            // ------------------------------------------------
            // OPERATIONAL HEALTH CARD
            // ------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.insights_outlined,
                      size: 22,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Response time: healthy",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "You’re replying to most chats within 30 minutes. Maintain this to stay at the top of buyer preference.",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ===============================
// KPI CARD WIDGET
// ===============================
class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String chip;
  final IconData icon;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.chip,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              chip,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================
// QUICK ACTION TILE
// ===============================
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: colors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ===============================
// RECENT LISTING ROW
// ===============================
class _ListingRowCard extends StatelessWidget {
  final String title;
  final String statusLabel;
  final Color statusColor;
  final int views;
  final int chats;
  final String updated;

  const _ListingRowCard({
    required this.title,
    required this.statusLabel,
    required this.statusColor,
    required this.views,
    required this.chats,
    required this.updated,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.phone_iphone_rounded, size: 26),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      updated,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.visibility_outlined, size: 14),
                    const SizedBox(width: 3),
                    Text("$views views", style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 10),
                    const Icon(Icons.chat_bubble_outline, size: 14),
                    const SizedBox(width: 3),
                    Text("$chats chats", style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
