import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prayer_topic.dart';
import '../models/session.dart';
import '../providers/sessions_provider.dart';

class SessionPage extends StatefulWidget {
  final List<PrayerTopic> topics;
  final int durationPerTopicSeconds;

  const SessionPage({
    super.key,
    required this.topics,
    required this.durationPerTopicSeconds,
  });

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  late int _remainingSeconds;
  int _currentTopicIndex = 0;
  Timer? _timer;
  bool _isPaused = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationPerTopicSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isCompleted) return;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _moveToNextTopic();
        }
      });
    });
  }

  void _moveToNextTopic() {
    if (_currentTopicIndex < widget.topics.length - 1) {
      setState(() {
        _currentTopicIndex++;
        _remainingSeconds = widget.durationPerTopicSeconds;
      });
    } else {
      _completeSession();
    }
  }

  void _completeSession() {
    _timer?.cancel();

    final now = DateTime.now();
    final session = Session(
      name: 'Prayer Session',
      totalDurationSeconds: widget.topics.length * widget.durationPerTopicSeconds,
      createdAt: now,
      completedAt: now,
    );

    if (mounted) {
      context.read<SessionsProvider>().saveSession(session);
    }

    setState(() {
      _isCompleted = true;
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _skipTopic() {
    _moveToNextTopic();
  }

  void _stopSession() {
    Navigator.of(context).pop();
  }

  String _formatTime(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Session Complete'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Prayer Session Completed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Finish'),
              ),
            ],
          ),
        ),
      );
    }

    final currentTopic = widget.topics[_currentTopicIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Session'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _stopSession,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Topic ${_currentTopicIndex + 1} of ${widget.topics.length}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              currentTopic.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            if (currentTopic.description != null && currentTopic.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                currentTopic.description!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
            const Spacer(),
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w300,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _togglePause,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  iconSize: 48,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                IconButton(
                  onPressed: _skipTopic,
                  icon: const Icon(Icons.skip_next),
                  iconSize: 48,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
