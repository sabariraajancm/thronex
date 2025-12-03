import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: "Name")),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: "Mobile Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: "Email (optional)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
