import 'dart:io';
import 'package:fashion_outfit/controller/upload_controller.dart';
import 'package:flutter/material.dart';

class UploadCard extends StatelessWidget {
  final UploadController controller;
  final VoidCallback onUpdate;

  const UploadCard({super.key, required this.controller, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () async {
          await controller.pickImage();
          onUpdate();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: controller.selectedImage == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_file_rounded,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap to upload an image',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload a photo of someone wearing clothes',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(controller.selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
