import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/sessions_provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Consumer<SessionsProvider>(
        builder: (context, provider, child) {
          if (provider.sessions.isEmpty) {
            return const Center(
              child: Text('No prayer history yet.'),
            );
          }

          return ListView.builder(
            itemCount: provider.sessions.length,
            itemBuilder: (context, index) {
              final session = provider.sessions[index];
              final duration = Duration(seconds: session.totalDurationSeconds);
              final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
              final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
              
              return ListTile(
                title: Text(session.name),
                subtitle: Text(
                  DateFormat.yMMMd().add_jm().format(session.createdAt),
                ),
                trailing: Text(
                  '$minutes:$seconds',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
