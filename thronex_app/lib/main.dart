import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:thronex_app/profile/profile_page.dart';
import 'chat/chat_list_page.dart';
import 'package:thronex_app/listings/my_listings_page.dart';

void main() {
  runApp(const ThronexApp());
}

class ThronexApp extends StatelessWidget {
  const ThronexApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme.light(
      primary: Color(0xFF5B2EFF),
      onPrimary: Colors.white,
      secondary: Color(0xFF6C757D),
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1F2933),
      background: Color(0xFFF5F5FA),
      onBackground: Color(0xFF1F2933),
      error: Color(0xFFE53935),
      onError: Colors.white,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: Color(0xFF1F2933),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thronex',
      theme: baseTheme,
      home: const SplashScreen(),
    );
  }
}

// -------------------------------------------------------
// SPLASH SCREEN
// -------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ThronexHomeShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              child: Image.asset('assets/logo/thronex_logo.png'),
            ),
            const SizedBox(height: 16),
            // -------------------------------------
            // SEARCH BAR
            // -------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => GlobalSearchPage()));
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: colors.secondary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        "Search mobiles or spare parts",
                        style: TextStyle(fontSize: 13, color: colors.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Text(
              'Thronex',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Full-stack mobile lifecycle marketplace',
              style: TextStyle(fontSize: 13, color: colors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// HOME SHELL + LOCATION ENGINE
// -------------------------------------------------------
class ThronexHomeShell extends StatefulWidget {
  const ThronexHomeShell({super.key});

  @override
  State<ThronexHomeShell> createState() => _ThronexHomeShellState();
}

class _ThronexHomeShellState extends State<ThronexHomeShell> {
  int _currentIndex = 0;
  String? selectedCity = "Select";

  final _pages = [
    const HomePage(),
    SparePartsPage(),
    const SellerOnboardingPage(),
    ChatListPage(), // NEW CHAT SCREEN
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    loadSavedCity();
  }

  Future<void> loadSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCity = prefs.getString("city") ?? "Select";
    });
  }

  Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("city", city);
    setState(() => selectedCity = city);
  }

  Future<void> detectMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enable location services.")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied.")),
      );
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );

    if (placemarks.isNotEmpty) {
      final city = placemarks.first.locality ?? "Unknown";
      await saveCity(city);
    }
  }

  void openCitySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return CitySelector(
          onCitySelected: (city) async {
            await saveCity(city);
            Navigator.pop(context);
          },
          onAutoDetect: () async {
            await detectMyLocation();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SellerOnboardingPage()),
          );
        },
        icon: const Icon(Icons.sell),
        label: const Text("Sell Device"),
      ),

      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 32,
              child: Image.asset('assets/logo/thronex_logo.png'),
            ),
            const SizedBox(width: 8),
            const Text('Thronex'),
            const Spacer(),
            GestureDetector(
              onTap: openCitySelector,
              child: Row(
                children: [
                  Text(
                    selectedCity ?? "Select",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5B2EFF),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        height: 70,
        indicatorColor: const Color(0x225B2EFF),
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.phone_iphone_outlined, size: 30),
            selectedIcon: Icon(
              Icons.phone_iphone,
              size: 32,
              color: Color(0xFF5B2EFF),
            ),
            label: 'Mobiles',
          ),
          NavigationDestination(
            icon: Icon(Icons.memory_outlined, size: 30),
            selectedIcon: Icon(
              Icons.memory,
              size: 32,
              color: Color(0xFF5B2EFF),
            ),
            label: 'Spares',
          ),
          NavigationDestination(
            icon: Icon(Icons.sell_outlined, size: 30),
            selectedIcon: Icon(Icons.sell, size: 32, color: Color(0xFF5B2EFF)),
            label: 'Sell',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, size: 30),
            selectedIcon: Icon(
              Icons.chat_bubble,
              size: 32,
              color: Color(0xFF5B2EFF),
            ),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, size: 30),
            selectedIcon: Icon(
              Icons.person,
              size: 32,
              color: Color(0xFF5B2EFF),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class colors {
  static Color? get primary => null;
}

// -------------------------------------------------------
// CITY SELECTOR BOTTOM SHEET
// -------------------------------------------------------
class CitySelector extends StatefulWidget {
  final Future<void> Function(String) onCitySelected;
  final Future<void> Function() onAutoDetect;

  const CitySelector({
    super.key,
    required this.onCitySelected,
    required this.onAutoDetect,
  });

  @override
  State<CitySelector> createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  final List<String> _allCities = const [
    "Chennai",
    "Coimbatore",
    "Madurai",
    "Trichy",
    "Salem",
    "Tirunelveli",
    "Bangalore",
    "Hyderabad",
    "Mumbai",
    "Delhi",
    "Pune",
    "Kochi",
    "Kolkata",
    "Ahmedabad",
    "Jaipur",
  ];

  String _search = "";

  @override
  Widget build(BuildContext context) {
    final filtered = _allCities
        .where((city) => city.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose your location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: "Search city",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: widget.onAutoDetect,
              icon: const Icon(Icons.my_location),
              label: const Text("Use current location"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                backgroundColor: const Color(0xFF5B2EFF),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(filtered[i]),
                    onTap: () => widget.onCitySelected(filtered[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// MOBILE DEVICE MODEL
// -------------------------------------------------------
class MobileDevice {
  final String brand;
  final String model;
  final String price;
  final String condition;
  final String storage;
  final String location;
  final String battery;
  final String warranty;
  final String sellerType;
  final bool isVerified;

  const MobileDevice({
    required this.brand,
    required this.model,
    required this.price,
    required this.condition,
    required this.storage,
    required this.location,
    required this.battery,
    required this.warranty,
    required this.sellerType,
    required this.isVerified,
  });
}

// -------------------------------------------------------
// PREMIUM HOME UI
// -------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<MobileDevice> get featuredMobiles => const [
    MobileDevice(
      brand: "Apple",
      model: "iPhone 13",
      price: "₹42,999",
      condition: "Like New",
      storage: "128 GB",
      location: "Chennai",
      battery: "92%",
      warranty: "3 months seller warranty",
      sellerType: "Verified Shop",
      isVerified: true,
    ),
    MobileDevice(
      brand: "Samsung",
      model: "Galaxy S21 FE",
      price: "₹24,499",
      condition: "Good",
      storage: "128 GB",
      location: "Bangalore",
      battery: "88%",
      warranty: "No warranty",
      sellerType: "Individual",
      isVerified: false,
    ),
    MobileDevice(
      brand: "OnePlus",
      model: "Nord CE 3",
      price: "₹18,999",
      condition: "Refurbished",
      storage: "8 GB / 128 GB",
      location: "Hyderabad",
      battery: "90%",
      warranty: "6 months seller warranty",
      sellerType: "Verified Shop",
      isVerified: true,
    ),
  ];

  void _openListing(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MobileListingPage()));
  }

  void _openSeller(BuildContext ctx) {
    Navigator.of(
      ctx,
    ).push(MaterialPageRoute(builder: (_) => const SellerOnboardingPage()));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // -------------------------------------
          // HERO BANNER
          // -------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B2EFF), Color(0xFF8E67FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Upgrade your device\nSpend less with Thronex.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Verified sellers • Assured devices",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: () => _openListing(context),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.shopping_bag_outlined, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "Browse mobiles",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.phone_iphone_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // -------------------------------------
          // CATEGORY GRID
          // -------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Explore by category",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _CategoryCard(
                  icon: Icons.phone_iphone,
                  title: "Buy Mobiles",
                  subtitle: "Certified pre-owned",
                  onTap: () => _openListing(context),
                ),
                _CategoryCard(
                  icon: Icons.memory,
                  title: "Spare Parts",
                  subtitle: "Screens, Batteries",
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => SparePartsPage()));
                  },
                ),
                _CategoryCard(
                  icon: Icons.build,
                  title: "Service & Repair",
                  subtitle: "Trusted partners",
                  onTap: () {},
                ),
                _CategoryCard(
                  icon: Icons.sell,
                  title: "Sell Device",
                  subtitle: "List instantly",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RepairPartnerPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const SizedBox(height: 18),

          // -------------------------------------
          // TOP BRANDS
          // -------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Top brands",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
          ),

          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _BrandChip(
                  label: "Apple",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _BrandChip(
                  label: "Samsung",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _BrandChip(
                  label: "OnePlus",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _BrandChip(
                  label: "Xiaomi",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _BrandChip(
                  label: "Vivo",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _BrandChip(
                  label: "Oppo",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // -------------------------------------
          // TRENDING SEARCHES
          // -------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Trending searches",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChipPill(
                  label: "Under ₹10,000",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _FilterChipPill(
                  label: "Under ₹20,000",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _FilterChipPill(
                  label: "iPhone XR",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _FilterChipPill(
                  label: "OnePlus Nord",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _FilterChipPill(
                  label: "8 GB RAM",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
                _FilterChipPill(
                  label: "Gaming phones",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // -------------------------------------
          // FEATURED NEAR YOU
          // -------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Featured near you",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MobileListingPage()),
                    );
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featuredMobiles.length,
            itemBuilder: (context, index) {
              final item = featuredMobiles[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MobileDetailPage(device: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: colors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.phone_iphone_rounded,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.brand} ${item.model}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${item.storage} • ${item.condition}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      item.price,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: colors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: colors.secondary,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      item.location,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: colors.secondary,
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
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// SUPPORT WIDGETS (CATEGORY / BRANDS / FILTER CHIPS)
// -------------------------------------------------------
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 22, color: colors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: colors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _BrandChip({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _FilterChipPill extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _FilterChipPill({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.grey.shade200),
          color: colors.surface,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// MOBILE LISTING PAGE
// -------------------------------------------------------
class MobileListingPage extends StatelessWidget {
  MobileListingPage({super.key});

  final List<MobileDevice> devices = const [
    MobileDevice(
      brand: "Apple",
      model: "iPhone 12",
      price: "₹35,499",
      condition: "Like New",
      storage: "64 GB",
      location: "Chennai",
      battery: "90%",
      warranty: "3 months seller warranty",
      sellerType: "Verified Shop",
      isVerified: true,
    ),
    MobileDevice(
      brand: "Apple",
      model: "iPhone 11",
      price: "₹25,999",
      condition: "Good",
      storage: "128 GB",
      location: "Coimbatore",
      battery: "85%",
      warranty: "No warranty",
      sellerType: "Individual",
      isVerified: false,
    ),
    MobileDevice(
      brand: "Samsung",
      model: "Galaxy A54",
      price: "₹21,999",
      condition: "Like New",
      storage: "128 GB",
      location: "Bangalore",
      battery: "93%",
      warranty: "6 months seller warranty",
      sellerType: "Verified Shop",
      isVerified: true,
    ),
    MobileDevice(
      brand: "OnePlus",
      model: "OnePlus 9R",
      price: "₹19,999",
      condition: "Refurbished",
      storage: "8 GB / 128 GB",
      location: "Hyderabad",
      battery: "88%",
      warranty: "3 months seller warranty",
      sellerType: "Verified Shop",
      isVerified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Buy Mobiles")),
      body: Column(
        children: [
          // FILTER ROW
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                _SmallFilterChip(icon: Icons.sort, label: "Sort", onTap: () {}),
                const SizedBox(width: 8),
                _SmallFilterChip(
                  icon: Icons.currency_rupee,
                  label: "Budget",
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                _SmallFilterChip(
                  icon: Icons.check_circle_outline,
                  label: "Condition",
                  onTap: () {},
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.grid_view_rounded),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, i) {
                final d = devices[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MobileDetailPage(device: d),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.phone_iphone_rounded),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        d.brand,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        d.model,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (d.isVerified) ...[
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.verified,
                                          size: 16,
                                          color: Color(0xFF22C55E),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${d.storage} • ${d.condition}",
                                    style: TextStyle(color: colors.secondary),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        d.price,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: colors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: colors.secondary,
                                      ),
                                      Text(
                                        " ${d.location}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: colors.secondary,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallFilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SmallFilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.grey.shade300),
          color: colors.surface,
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: colors.onSurface),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// PRODUCT DETAIL PAGE
// -------------------------------------------------------
class MobileDetailPage extends StatelessWidget {
  final MobileDevice device;

  const MobileDetailPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("${device.brand} ${device.model}")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // DEVICE IMAGE
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.phone_iphone_rounded, size: 80),
            ),

            // PRIMARY DEVICE INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${device.brand} ${device.model}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${device.storage} • ${device.condition}",
                    style: TextStyle(fontSize: 13, color: colors.secondary),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    device.price,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: colors.secondary,
                      ),
                      Text(
                        " ${device.location}",
                        style: TextStyle(fontSize: 12, color: colors.secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),

            // DIAGNOSTICS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Device diagnostics",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _DiagnosticRow(
                    label: "Overall condition",
                    value: device.condition,
                  ),
                  _DiagnosticRow(
                    label: "Battery health",
                    value: device.battery,
                  ),
                  _DiagnosticRow(label: "Warranty", value: device.warranty),
                  _DiagnosticRow(
                    label: "Original parts",
                    value: "Seller confirmed",
                  ),
                  _DiagnosticRow(label: "Display", value: "No major scratches"),
                  _DiagnosticRow(label: "IMEI status", value: "Clean"),
                ],
              ),
            ),

            const Divider(height: 1),

            // SELLER CARD
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: colors.primary.withOpacity(0.1),
                      child: Icon(
                        device.sellerType == "Verified Shop"
                            ? Icons.storefront
                            : Icons.person,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        device.sellerType,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (device.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0FBE2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.verified,
                              size: 14,
                              color: Color(0xFF16A34A),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Verified",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF166534),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // ACTIONS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text("Chat seller"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.call),
                      label: const Text("Call seller"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SAFETY MESSAGE
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: colors.secondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Meet in safe public places and verify device before paying.",
                      style: TextStyle(fontSize: 11, color: colors.secondary),
                    ),
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

class _DiagnosticRow extends StatelessWidget {
  final String label;
  final String value;

  const _DiagnosticRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: colors.secondary),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// SELLER ONBOARDING ENGINE
// -------------------------------------------------------
class SellerOnboardingPage extends StatefulWidget {
  const SellerOnboardingPage({super.key});

  @override
  State<SellerOnboardingPage> createState() => _SellerOnboardingPageState();
}

class _SellerOnboardingPageState extends State<SellerOnboardingPage> {
  String sellerType = "Individual";

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and mobile number are required.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sellerType == "Individual"
              ? "Individual seller profile saved."
              : "Shop seller profile saved.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Seller Onboarding")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You are registering as",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                _SellerTypeChip(
                  label: "Individual",
                  selected: sellerType == "Individual",
                  onTap: () => setState(() => sellerType = "Individual"),
                ),
                const SizedBox(width: 10),
                _SellerTypeChip(
                  label: "Shop Owner",
                  selected: sellerType == "Shop Owner",
                  onTap: () => setState(() => sellerType = "Shop Owner"),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              "Basic details",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: "Enter your full name",
              ),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Mobile number",
                hintText: "Enter mobile number",
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email (optional)",
                hintText: "Enter email",
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            if (sellerType == "Shop Owner") ...[
              const SizedBox(height: 20),
              const Text(
                "Shop details",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _shopNameController,
                decoration: const InputDecoration(labelText: "Shop name"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _shopAddressController,
                decoration: const InputDecoration(labelText: "Shop address"),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
            ],

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colors.primary.withOpacity(0.05),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Your seller profile enhances marketplace trust. Verification comes later.",
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text("Save & continue"),
              ),
            ),

            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
              ),
              child: const Text("Skip for now"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SellerTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SellerTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? colors.primary : Colors.white,
          border: Border.all(
            color: selected ? colors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : colors.onSurface,
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// PLACEHOLDER PAGE
// -------------------------------------------------------
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '$title – coming soon',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// SPARE PARTS MODULE (GRID PREMIUM)
// -------------------------------------------------------
class SparePart {
  final String type;
  final String model;
  final String brand;
  final String condition;
  final String price;
  final String sellerType;
  final bool isVerified;

  const SparePart({
    required this.type,
    required this.model,
    required this.brand,
    required this.condition,
    required this.price,
    required this.sellerType,
    required this.isVerified,
  });
}

class SparePartsPage extends StatelessWidget {
  SparePartsPage({super.key});

  final List<SparePart> parts = const [
    SparePart(
      type: "Display",
      model: "iPhone XR",
      brand: "Apple",
      condition: "New",
      price: "₹4,999",
      sellerType: "Verified Shop",
      isVerified: true,
    ),
    SparePart(
      type: "Battery",
      model: "Samsung A54",
      brand: "Samsung",
      condition: "Refurbished",
      price: "₹1,299",
      sellerType: "Individual",
      isVerified: false,
    ),
    SparePart(
      type: "Camera Module",
      model: "OnePlus 9R",
      brand: "OnePlus",
      condition: "New",
      price: "₹1,899",
      sellerType: "Verified Shop",
      isVerified: true,
    ),
    SparePart(
      type: "Back Glass",
      model: "iPhone 12",
      brand: "Apple",
      condition: "Used",
      price: "₹899",
      sellerType: "Individual",
      isVerified: false,
    ),
    SparePart(
      type: "Charging Port",
      model: "Redmi Note 10",
      brand: "Xiaomi",
      condition: "New",
      price: "₹299",
      sellerType: "Verified Shop",
      isVerified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Spare Parts")),
      body: Column(
        children: [
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                _PartsFilterChip(label: "Display"),
                _PartsFilterChip(label: "Battery"),
                _PartsFilterChip(label: "Camera"),
                _PartsFilterChip(label: "Motherboard"),
                _PartsFilterChip(label: "Back Glass"),
                _PartsFilterChip(label: "Charging Port"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: parts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, i) {
                final p = parts[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SparePartDetailPage(part: p),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ICON BOX
                        Container(
                          height: 68,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: colors.primary.withOpacity(0.08),
                          ),
                          child: const Icon(Icons.settings, size: 34),
                        ),

                        const SizedBox(height: 10),
                        Text(
                          p.type,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${p.brand} • ${p.model}",
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.secondary,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colors.primary.withOpacity(0.08),
                          ),
                          child: Text(
                            p.condition,
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Text(
                          p.price,
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              p.sellerType,
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.secondary,
                              ),
                            ),
                            if (p.isVerified)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: Colors.green,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PartsFilterChip extends StatelessWidget {
  final String label;
  const _PartsFilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// =======================================
// SPARE PART DETAIL PAGE — D1 PREMIUM
// =======================================

class SparePartDetailPage extends StatelessWidget {
  final SparePart part;
  const SparePartDetailPage({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // GRADIENT HEADER
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5B2EFF),
                  Color(0xFF9C6BFF),
                  Color(0xFFC0C4D6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // BACK BUTTON
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // FLOATING CONTENT
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.86,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.settings,
                        size: 46,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      part.type,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${part.brand} • ${part.model}",
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // MAIN CONTENT
          Positioned.fill(
            top: 340,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PRICE BLOCK
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Text(
                          part.price,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (part.condition == "Refurbished")
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Refurbished",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (part.isVerified)
                          Row(
                            children: const [
                              Icon(
                                Icons.verified,
                                size: 18,
                                color: Color(0xFF22C55E),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Verified Shop",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF166534),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SPECIFICATIONS
                  const Text(
                    "Specifications",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  _SpecRow(label: "Part Type", value: part.type),
                  _SpecRow(label: "Compatible Model", value: part.model),
                  _SpecRow(label: "Brand", value: part.brand),
                  _SpecRow(label: "Condition", value: part.condition),
                  _SpecRow(label: "Seller Type", value: part.sellerType),
                  _SpecRow(
                    label: "Verification",
                    value: part.isVerified ? "Verified Shop" : "Individual",
                  ),
                  const SizedBox(height: 4),

                  const SizedBox(height: 20),

                  // QC / CHECKLIST
                  const Text(
                    "Quality Check Summary",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const _BulletPoint(text: "Part visually inspected"),
                  const _BulletPoint(text: "No cracks or defects found"),
                  const _BulletPoint(text: "Compatibility tested"),
                  const _BulletPoint(text: "Seller confirmed originality"),

                  const SizedBox(height: 20),

                  // SELLER CARD
                  const Text(
                    "Seller Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: colors.primary.withOpacity(0.12),
                          child: Icon(
                            part.isVerified ? Icons.storefront : Icons.person,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                part.sellerType,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Response time: 30–60 mins (typical)",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (part.isVerified)
                          const Icon(
                            Icons.verified,
                            size: 20,
                            color: Color(0xFF22C55E),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ACTION BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline),
                          onPressed: () {},
                          label: const Text("Chat Seller"),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.call),
                          onPressed: () {},
                          label: const Text("Call Seller"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // SAFETY
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 18,
                        color: colors.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Check compatibility and test the part during installation.",
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;
  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: colors.secondary),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xFF5B2EFF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search mobiles or spare parts",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Start typing to explore listings…",
              style: TextStyle(color: colors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class RepairPartnerPage extends StatelessWidget {
  const RepairPartnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service & Repair")),
      body: const Center(
        child: Text(
          "Trusted repair partners coming soon.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
