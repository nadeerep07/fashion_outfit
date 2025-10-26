
import 'package:fashion_outfit/widgets/detected_items_grid.dart';
import 'package:fashion_outfit/widgets/error_message_box.dart';
import 'package:fashion_outfit/widgets/generate_button.dart';
import 'package:fashion_outfit/widgets/shimmer_grid.dart';
import 'package:fashion_outfit/widgets/upload_card.dart';
import 'package:flutter/material.dart';
import 'package:fashion_outfit/controller/upload_controller.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final UploadController _controller = UploadController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Outfit Item Extractor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UploadCard(
                controller: _controller,
                onUpdate: () => setState(() {}),
              ),
              const SizedBox(height: 24),
              GenerateButton(
                controller: _controller,
                onUpdate: () => setState(() {}),
              ),
              const SizedBox(height: 24),
              if (_controller.errorMessage != null)
                ErrorMessageBox(errorMessage: _controller.errorMessage!),
              if (_controller.isGenerating)
                ShimmerGrid(
                  itemCount: _controller.detectedItems.isNotEmpty
                      ? _controller.detectedItems.length
                      : 4,
                ),
              if (!_controller.isGenerating &&
                  _controller.detectedItems.isNotEmpty)
                DetectedItemsGrid(items: _controller.detectedItems),
            ],
          ),
        ),
      ),
    );
  }
}
