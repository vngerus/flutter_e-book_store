import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../models/ebook_models.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/app_colors.dart';

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
        title: Text(
          widget.book.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.texto3,
          ),
        ),
        backgroundColor: AppColor.bg1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColor.bg2,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColor.bg1,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.bg2, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.book.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.texto3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "By ${widget.book.author}",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.texto3,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.book.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColor.texto2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progress:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.texto3,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bg1,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColor.bg2, width: 2),
                    ),
                  ),
                  child: Text(
                    "Restart Reading",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.texto3,
                    ),
                  ),
                ),
            ],
          ),
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
