import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'history_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Prayer History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Enable daily prayer reminders'),
                value: provider.notificationsEnabled,
                onChanged: (value) {
                  provider.toggleNotifications(value);
                },
              ),
              SwitchListTile(
                title: const Text('Streak Tracking'),
                subtitle: const Text('Track your daily prayer streaks'),
                value: provider.streakEnabled,
                onChanged: (value) {
                  provider.toggleStreak(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
