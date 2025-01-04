import 'package:flutter/material.dart';
import '../models/ebook_models.dart';

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

  @override
  void initState() {
    super.initState();
    _progress = widget.book.progress;
  }

  void _updateProgress(double value) {
    setState(() {
      _progress = value;
    });
    widget.onProgressUpdated(_progress);
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
              onChanged: _updateProgress,
              activeColor: Colors.teal,
              inactiveColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
