import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/topics_provider.dart';
import '../models/prayer_topic.dart';
import 'session_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _minutesPerTopic = 2;
  final Set<int> _selectedTopicIds = {};

  @override
  void initState() {
    super.initState();
    // We can't access context in initState to get the provider easily without listen: false
    // But we can initialize selection later or rely on user input.
    // Ideally, we might want to select all by default or load previous preference.
    // For now, let's leave it empty or select all once topics are loaded.
  }

  void _startSession(List<PrayerTopic> allTopics) {
    final selectedTopics = allTopics
        .where((t) => _selectedTopicIds.contains(t.id))
        .toList();

    if (selectedTopics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one topic to start.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionPage(
          topics: selectedTopics,
          durationPerTopicSeconds: (_minutesPerTopic * 60).round(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Session'),
      ),
      body: Consumer<TopicsProvider>(
        builder: (context, topicsProvider, child) {
          final topics = topicsProvider.topics;

          if (topics.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No prayer topics found.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Topics page or show add dialog
                      // Assuming there is a Topics tab or way to add
                    },
                    child: const Text('Add Topics'),
                  ),
                ],
              ),
            );
          }

          // Initialize selection on first load if empty and not explicitly deselected? 
          // Or just let user select. Let's auto-select all if user hasn't interacted?
          // Simpler: just let user select. Or select all by default in a post-frame callback.
          // For this iteration, let's just rely on user clicking, or maybe "Select All" button.

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duration per Topic',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _minutesPerTopic,
                                min: 1,
                                max: 60,
                                divisions: 59,
                                label: '${_minutesPerTopic.round()} min',
                                onChanged: (value) {
                                  setState(() {
                                    _minutesPerTopic = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              '${_minutesPerTopic.round()} min',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Topics (${_selectedTopicIds.length}/${topics.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedTopicIds.length == topics.length) {
                            _selectedTopicIds.clear();
                          } else {
                            _selectedTopicIds.clear();
                            _selectedTopicIds.addAll(topics.map((t) => t.id!).whereType<int>());
                          }
                        });
                      },
                      child: Text(_selectedTopicIds.length == topics.length
                          ? 'Deselect All'
                          : 'Select All'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    final isSelected = _selectedTopicIds.contains(topic.id);

                    return CheckboxListTile(
                      title: Text(topic.title),
                      subtitle: topic.description != null ? Text(topic.description!) : null,
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (topic.id != null) {
                              _selectedTopicIds.add(topic.id!);
                            }
                          } else {
                            if (topic.id != null) {
                              _selectedTopicIds.remove(topic.id!);
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<TopicsProvider>(
        builder: (context, topicsProvider, child) {
          return FloatingActionButton.extended(
            onPressed: () => _startSession(topicsProvider.topics),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Prayer'),
          );
        },
      ),
    );
  }
}
