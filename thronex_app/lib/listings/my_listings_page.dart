import 'package:flutter/material.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  int _currentFilterIndex = 0; // 0 = Active, 1 = Under review, 2 = Sold

  // Dummy data – later this will come from backend / local DB
  final List<_ListingItem> _allListings = const [
    _ListingItem(
      title: "iPhone 12 • 64 GB",
      price: "₹32,999",
      location: "Chennai",
      status: ListingStatus.active,
      views: 124,
      chats: 5,
      isBoosted: true,
    ),
    _ListingItem(
      title: "OnePlus Nord CE 3",
      price: "₹18,499",
      location: "Coimbatore",
      status: ListingStatus.underReview,
      views: 18,
      chats: 1,
      isBoosted: false,
    ),
    _ListingItem(
      title: "Samsung Galaxy A54",
      price: "₹21,000",
      location: "Bangalore",
      status: ListingStatus.sold,
      views: 87,
      chats: 3,
      isBoosted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final filtered = _allListings.where((item) {
      switch (_currentFilterIndex) {
        case 0:
          return item.status == ListingStatus.active;
        case 1:
          return item.status == ListingStatus.underReview;
        case 2:
          return item.status == ListingStatus.sold;
        default:
          return true;
      }
    }).toList();

    final hasData = filtered.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text("My Listings")),
      backgroundColor: colors.background,
      body: Column(
        children: [
          // ----------------------------------------
          // FILTER SEGMENT (Active / Under review / Sold)
          // ----------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  _FilterChipTab(
                    label: "Active",
                    isSelected: _currentFilterIndex == 0,
                    onTap: () => setState(() => _currentFilterIndex = 0),
                  ),
                  _FilterChipTab(
                    label: "Under review",
                    isSelected: _currentFilterIndex == 1,
                    onTap: () => setState(() => _currentFilterIndex = 1),
                  ),
                  _FilterChipTab(
                    label: "Sold",
                    isSelected: _currentFilterIndex == 2,
                    onTap: () => setState(() => _currentFilterIndex = 2),
                  ),
                ],
              ),
            ),
          ),

          // Small info line
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                hasData
                    ? "${filtered.length} listing(s) in this bucket"
                    : "No listings in this bucket yet",
                style: TextStyle(fontSize: 12, color: colors.secondary),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ----------------------------------------
          // CONTENT AREA
          // ----------------------------------------
          Expanded(
            child: hasData
                ? ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _ListingCard(item: item);
                    },
                  )
                : _EmptyListingsState(filterIndex: _currentFilterIndex),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// DATA MODEL (LOCAL ONLY FOR NOW)
// -------------------------------------------------------
enum ListingStatus { active, underReview, sold }

class _ListingItem {
  final String title;
  final String price;
  final String location;
  final ListingStatus status;
  final int views;
  final int chats;
  final bool isBoosted;

  const _ListingItem({
    required this.title,
    required this.price,
    required this.location,
    required this.status,
    required this.views,
    required this.chats,
    required this.isBoosted,
  });
}

// -------------------------------------------------------
// FILTER TAB WIDGET
// -------------------------------------------------------
class _FilterChipTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isSelected ? colors.primary : Colors.white,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// LISTING CARD
// -------------------------------------------------------
class _ListingCard extends StatelessWidget {
  final _ListingItem item;

  const _ListingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    String statusLabel;
    Color statusColor;
    Color statusBg;

    switch (item.status) {
      case ListingStatus.active:
        statusLabel = "Active";
        statusColor = const Color(0xFF16A34A);
        statusBg = const Color(0xFFE0FBE2);
        break;
      case ListingStatus.underReview:
        statusLabel = "Under review";
        statusColor = const Color(0xFFCA8A04);
        statusBg = const Color(0xFFFEF3C7);
        break;
      case ListingStatus.sold:
        statusLabel = "Sold";
        statusColor = const Color(0xFFDC2626);
        statusBg = const Color(0xFFFEE2E2);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_iphone_rounded),
              ),
              const SizedBox(width: 12),
              // Text + meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Status chip
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
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
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.price,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.location,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Views & chats row
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${item.views}",
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${item.chats}",
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.secondary,
                          ),
                        ),
                        if (item.isBoosted) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFEFF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              "Boosted",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0891B2),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Actions
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // Future: open Edit Listing flow
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            // Future: open Promote / Boost actions
                          },
                          child: const Text(
                            "More options",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// EMPTY STATE FOR EACH BUCKET
// -------------------------------------------------------
class _EmptyListingsState extends StatelessWidget {
  final int filterIndex; // 0,1,2

  const _EmptyListingsState({required this.filterIndex});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    String title;
    String subtitle;

    switch (filterIndex) {
      case 0:
        title = "No active listings yet";
        subtitle =
            "Start listing your mobiles or spare parts to reach nearby buyers.";
        break;
      case 1:
        title = "Nothing under review";
        subtitle =
            "Once you submit a new listing, it will show here during review.";
        break;
      case 2:
        title = "No sold history yet";
        subtitle =
            "After your listings are marked as sold, they’ll appear in this tab.";
        break;
      default:
        title = "No listings found";
        subtitle = "Create a listing to get started.";
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_android_outlined,
              size: 60,
              color: colors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.secondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // For now just route back; user can tap "Sell" FAB in home shell
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.add),
              label: const Text("Create a listing"),
            ),
          ],
        ),
      ),
    );
  }
}
