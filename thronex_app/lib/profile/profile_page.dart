import 'package:flutter/material.dart';
import '../listings/my_listings_page.dart';
import '../saved/saved_wishlist_page.dart';
import 'edit_profile_page.dart';
import 'package:thronex_app/settings/settings_page.dart';
import 'package:thronex_app/orders/my_orders_page.dart';
import 'package:thronex_app/wishlist/wishlist_page.dart';
import 'package:thronex_app/seller/seller_center_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // =============================
            // PRIMARY MENU LISTTILES
            // =============================
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text(
                "My Listings",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyListingsPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text(
                "Saved / Wishlist",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedWishlistPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text(
                "My Orders",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text(
                "Settings & Privacy",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),

            // =============================
            // GRADIENT PROFILE HEADER
            // =============================
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B2EFF), Color(0xFF9C6BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: colors.primary.withOpacity(0.15),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Your Name",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Seller • Shop Owner",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 22),
                            onPressed: () {
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
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =============================
            // QUICK ACTIONS
            // =============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ActionTile(
                        icon: Icons.phone_android,
                        label: "My Listings",
                        onTap: () {},
                      ),
                      _ActionTile(
                        icon: Icons.favorite_border,
                        label: "Saved Items",
                        onTap: () {},
                      ),
                      _ActionTile(
                        icon: Icons.chat_bubble_outline,
                        label: "My Chats",
                        onTap: () {},
                      ),
                      _ActionTile(
                        icon: Icons.storefront,
                        label: "Seller Center",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SellerCenterPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =============================
            // ACCOUNT SECTION
            // =============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _SettingTile(
                    icon: Icons.person_outline,
                    label: "Edit Profile",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
                    },
                  ),
                  _SettingTile(
                    icon: Icons.notifications_outlined,
                    label: "Notifications",
                    onTap: () {},
                  ),
                  _SettingTile(
                    icon: Icons.settings,
                    label: "Settings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                  ),
                  _SettingTile(
                    icon: Icons.logout,
                    label: "Logout",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================
// SUPPORTING COMPONENTS
// =============================

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 22, color: colors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
