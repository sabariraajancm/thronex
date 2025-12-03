import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings & Privacy")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // -----------------------
          // ACCOUNT SETTINGS
          // -----------------------
          const SectionHeader(title: "Account Settings"),

          SettingsTile(
            icon: Icons.person_outline,
            title: "Edit Profile",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            title: "Change Password",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.verified_user_outlined,
            title: "Account Verification (KYC)",
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // -----------------------
          // APP PREFERENCES
          // -----------------------
          const SectionHeader(title: "App Preferences"),

          SettingsTile(
            icon: Icons.notifications_none,
            title: "Notification Settings",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.language_outlined,
            title: "Language",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: "Dark Mode",
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // -----------------------
          // PRIVACY & SECURITY
          // -----------------------
          const SectionHeader(title: "Privacy & Security"),

          SettingsTile(
            icon: Icons.security_outlined,
            title: "Privacy Policy",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.delete_forever_outlined,
            title: "Delete My Account",
            textColor: Colors.red,
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // -----------------------
          // ABOUT SYSTEM
          // -----------------------
          const SectionHeader(title: "About"),

          SettingsTile(
            icon: Icons.info_outline,
            title: "About Thronex App",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.code_outlined,
            title: "Version 1.0.0",
            onTap: () {},
          ),

          const SizedBox(height: 30),

          // LOGOUT
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------
// REUSABLE WIDGETS
// ------------------------------

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: colors.primary, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor ?? colors.onSurface,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 16, bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: colors.secondary,
        ),
      ),
    );
  }
}
