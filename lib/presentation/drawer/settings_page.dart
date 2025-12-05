import 'package:flutter/material.dart';
import '../../src/generated/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Open language selection dialog
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(l10n.theme),
            trailing: Switch(
              value: false, // Should come from AppCubit
              onChanged: (val) {
                // Toggle theme logic
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.notifications),
            trailing: Switch(
              value: true,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }
}