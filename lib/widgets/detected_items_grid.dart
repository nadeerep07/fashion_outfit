import 'package:fashion_outfit/model/clothing_item.dart';
import 'package:fashion_outfit/widgets/outfit_item_card.dart';
import 'package:flutter/material.dart';

class DetectedItemsGrid extends StatelessWidget {
  final List<ClothingItem> items;

  const DetectedItemsGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.checkroom, size: 24),
            const SizedBox(width: 8),
            Text(
              'Detected Items (${items.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return OutfitItemCard(item: item);
          },
        ),
      ],
    );
  }
}