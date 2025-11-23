import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/topics_provider.dart';
import '../models/prayer_topic.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
      ),
      body: Consumer<TopicsProvider>(
        builder: (context, provider, child) {
          if (provider.topics.isEmpty) {
            return const Center(
              child: Text('No topics available.'),
            );
          }
          return ListView.builder(
            itemCount: provider.topics.length,
            itemBuilder: (context, index) {
              final topic = provider.topics[index];
              return ListTile(
                title: Text(topic.title),
                subtitle: topic.category != null ? Text(topic.category!) : null,
                onTap: () => _showTopicDialog(context, topic: topic),
                trailing: !topic.isDefault
                    ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          if (topic.id != null) {
                            provider.deleteTopic(topic.id!);
                          }
                        },
                      )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTopicDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTopicDialog(BuildContext context, {PrayerTopic? topic}) {
    final TextEditingController titleController =
        TextEditingController(text: topic?.title);
    final TextEditingController categoryController =
        TextEditingController(text: topic?.category);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(topic == null ? 'Add New Topic' : 'Edit Topic'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: categoryController,
                decoration:
                    const InputDecoration(labelText: 'Category (Optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  if (topic == null) {
                    final newTopic = PrayerTopic(
                      title: titleController.text,
                      category: categoryController.text.isNotEmpty
                          ? categoryController.text
                          : null,
                      createdAt: DateTime.now(),
                    );
                    Provider.of<TopicsProvider>(context, listen: false)
                        .addTopic(newTopic);
                  } else {
                    final updatedTopic = PrayerTopic(
                      id: topic.id,
                      title: titleController.text,
                      category: categoryController.text.isNotEmpty
                          ? categoryController.text
                          : null,
                      isDefault: topic.isDefault,
                      createdAt: topic.createdAt,
                    );
                    Provider.of<TopicsProvider>(context, listen: false)
                        .updateTopic(updatedTopic);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(topic == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }
}
