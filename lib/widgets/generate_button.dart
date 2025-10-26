import 'package:fashion_outfit/controller/upload_controller.dart';
import 'package:flutter/material.dart';

class GenerateButton extends StatelessWidget {
  final UploadController controller;
  final VoidCallback onUpdate;

  const GenerateButton({super.key, required this.controller, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: controller.isGenerating
          ? null
          : () async {
              await controller.generateOutfits();
              onUpdate();
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: controller.isGenerating
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Detecting & Generating Items...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : const Text(
              'Extract Clothing Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
