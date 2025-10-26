import 'dart:io';
import 'package:fashion_outfit/model/clothing_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants/prompt.dart'; 

class UploadController {
  File? selectedImage;
  bool isGenerating = false;
  List<ClothingItem> detectedItems = [];
  String? errorMessage;

  final ImagePicker _picker = ImagePicker();

  static const String _geminiApiKey = 'AIzaSyDkCSz6DwSMV07XdQXFupgdt-TMzjOWXvE';

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

  Future<void> generateOutfits(Function() onStateChange) async {
    if (selectedImage == null) {
      errorMessage = 'Please upload an image first';
      onStateChange();
      return;
    }

    // Prevent multiple clicks - set loading state immediately
    if (isGenerating) return;
    
    isGenerating = true;
    errorMessage = null;
    detectedItems.clear();
    onStateChange(); // Update UI to show loading state

    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash-exp', // Faster model
        apiKey: _geminiApiKey,
      );

      final imageBytes = await selectedImage!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      // Generate content with Gemini
      final response = await model.generateContent([
        Content.multi([TextPart(geminiDetectionPrompt), imagePart])
      ]);

      if (response.text != null) {
        final parsedItems = _parseDetectedItems(response.text!);
        
        // Generate all images in parallel instead of sequentially
        final imageGenerationTasks = <Future<ClothingItem?>>[];
        
        for (int i = 0; i < parsedItems.length; i++) {
          final itemData = parsedItems[i];
          imageGenerationTasks.add(
            _generateClothingItem(
              itemData['name']!,
              itemData['description']!,
              i,
            )
          );
        }

        // Wait for all images to generate in parallel
        final results = await Future.wait(imageGenerationTasks);
        
        // Filter out null values (failed generations)
        detectedItems = results.whereType<ClothingItem>().toList();
        
        if (detectedItems.isEmpty && parsedItems.isNotEmpty) {
          errorMessage = 'Failed to generate item images';
        }
      } else {
        errorMessage = 'No response from AI';
      }
    } catch (e) {
      errorMessage = 'Error generating items: $e';
    } finally {
      isGenerating = false;
      onStateChange(); // Update UI when done
    }
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

  // Combined method that generates image URL and creates ClothingItem
  Future<ClothingItem?> _generateClothingItem(
    String itemName,
    String description,
    int index,
  ) async {
    try {
      final imageUrl = _generateItemImageUrl(description, index);
      return ClothingItem(
        name: itemName,
        imageUrl: imageUrl,
      );
    } catch (e) {
      return null;
    }
  }

  // Synchronous URL generation (no need for async since it's just string manipulation)
  String _generateItemImageUrl(String description, int index) {
    final enhancedPrompt =
        'Ultra-realistic professional product photograph: $description. '
        'Shot with high-end DSLR camera, studio lighting with softbox setup creating natural shadows, '
        'pure white seamless background, perfectly centered composition, '
        'extreme detail showing fabric weave and texture, accurate color reproduction, '
        'commercial fashion photography quality, shot on 85mm lens with shallow depth, '
        'item displayed flat or on transparent mannequin form, '
        'photorealistic rendering, 4K ultra high definition, professional retouching';
    final encodedPrompt = Uri.encodeComponent(enhancedPrompt);
    return 'https://image.pollinations.ai/prompt/$encodedPrompt?width=512&height=512&seed=${index + 100}&nologo=true&enhance=true';
  }
}