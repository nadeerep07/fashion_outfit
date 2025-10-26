import 'dart:io';
import 'package:fashion_outfit/model/clothing_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants/prompt.dart'; // import the prompt

class UploadController {
  File? selectedImage;
  bool isGenerating = false;
  List<ClothingItem> detectedItems = [];
  String? errorMessage;

  final ImagePicker _picker = ImagePicker();

  static const String _geminiApiKey = '';

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage = File(image.path);
        detectedItems.clear();
        errorMessage = null;
      } else {
        errorMessage = 'No image selected';
      }
    } catch (e) {
      errorMessage = 'Error picking image: $e';
    }
  }

  Future<void> generateOutfits() async {
    if (selectedImage == null) {
      errorMessage = 'Please upload an image first';
      return;
    }

    isGenerating = true;
    errorMessage = null;
    detectedItems.clear();

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _geminiApiKey,
      );

      final imageBytes = await selectedImage!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([TextPart(geminiDetectionPrompt), imagePart])
      ]);

      if (response.text != null) {
        final parsedItems = _parseDetectedItems(response.text!);
        final List<ClothingItem> items = [];

        for (int i = 0; i < parsedItems.length; i++) {
          final itemData = parsedItems[i];

          final imageUrl = await _generateItemImage(
            itemData['name']!,
            itemData['description']!,
            i,
          );

          if (imageUrl != null) {
            items.add(ClothingItem(
              name: itemData['name']!,
              imageUrl: imageUrl,
            ));
          }
        }

        detectedItems = items;
      } else {
        errorMessage = 'No response from AI';
      }
    } catch (e) {
      errorMessage = 'Error generating items: $e';
    }

    isGenerating = false;
  }

  List<Map<String, String>> _parseDetectedItems(String text) {
    final List<Map<String, String>> items = [];
    final sections = text.split('---');

    for (var section in sections) {
      section = section.trim();
      if (section.isEmpty) continue;

      final itemMatch = RegExp(r'ITEM:\s*(.+?)(?=\n|$)', multiLine: true).firstMatch(section);
      final descMatch = RegExp(r'DESC:\s*(.+?)(?=\n---|\n*$)', multiLine: true, dotAll: true).firstMatch(section);

      if (itemMatch != null && descMatch != null) {
        final itemName = itemMatch.group(1)?.trim() ?? '';
        final itemDesc = descMatch.group(1)?.trim() ?? '';

        if (itemName.isNotEmpty && itemDesc.isNotEmpty) {
          items.add({
            'name': itemName,
            'description': itemDesc,
          });
        }
      }
    }
    return items;
  }

  Future<String?> _generateItemImage(
    String itemName,
    String description,
    int index,
  ) async {
    try {
      final enhancedPrompt =
          'Professional product photography of $description, isolated on pure white background, centered, high quality studio lighting, detailed texture, 4k resolution, product shot, no person wearing it, just the clothing item laid flat or on mannequin';
      final encodedPrompt = Uri.encodeComponent(enhancedPrompt);
      final imageUrl =
          'https://image.pollinations.ai/prompt/$encodedPrompt?width=512&height=512&seed=${index + 100}&nologo=true&enhance=true';
      return imageUrl;
    } catch (e) {
      return null;
    }
  }
}
