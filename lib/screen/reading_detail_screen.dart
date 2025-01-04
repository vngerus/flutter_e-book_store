import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../models/ebook_models.dart';
import '../bloc/cart_bloc.dart';

class ReadingDetailScreen extends StatefulWidget {
  final EbookModel book;
  final Function(double) onProgressUpdated;

  const ReadingDetailScreen({
    super.key,
    required this.book,
    required this.onProgressUpdated,
  });

  @override
  _ReadingDetailScreenState createState() => _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends State<ReadingDetailScreen> {
  late double _progress;
  Timer? _progressTimer;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _progress = widget.book.progress;
    _completed = _progress >= 1.0;

    if (!_completed) {
      _startAutoProgress();
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startAutoProgress() {
    if (_progress >= 1.0) return;

    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01;
          if (_progress >= 1.0) {
            _progress = 1.0;
            _completed = true;
            timer.cancel();
          }
        }
      });

      widget.onProgressUpdated(_progress);
      context.read<CartBloc>().updateBookProgress(widget.book.id, _progress);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.book.title),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.book.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "By ${widget.book.author}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.book.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Progress:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${(_progress * 100).round()}%",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: _progress,
              min: 0,
              max: 1,
              divisions: 100,
              label: "${(_progress * 100).round()}%",
              onChanged: _completed ? null : _updateProgress,
              activeColor: Colors.teal,
              inactiveColor: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            if (_completed)
              ElevatedButton(
                onPressed: _restartReading,
                child: const Text("Restart Reading"),
              ),
          ],
        ),
      ),
    );
  }

  void _updateProgress(double value) {
    setState(() {
      _progress = value;
    });

    widget.onProgressUpdated(_progress);
    context.read<CartBloc>().updateBookProgress(widget.book.id, _progress);
  }

  void _restartReading() {
    setState(() {
      _progress = 0.0;
      _completed = false;
    });
    _startAutoProgress();
    context.read<CartBloc>().updateBookProgress(widget.book.id, _progress);
  }
}
