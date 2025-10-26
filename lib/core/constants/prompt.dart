

const String geminiDetectionPrompt = '''
Analyze this image and identify ALL individual clothing items and accessories worn by the person.

For EACH item detected, provide:
1. Item name (e.g., "Kurta", "Jeans", "Shawl", "Shoes", "Watch", etc.)
2. Detailed description for image generation including:
   - Exact color(s) - BE VERY SPECIFIC about the actual colors you see
   - Material/fabric type
   - Pattern (solid, striped, printed, embroidered, etc.)
   - Style details (collar type, sleeve length, fit, etc.)
   - Any decorative elements (embroidery, buttons, prints, etc.)

IMPORTANT: Match the EXACT colors you see in the image!

Format your response EXACTLY like this (one item per line):
ITEM: [Item Name]
DESC: [Detailed description - start with exact color, then material, pattern, and style details]
---
ITEM: [Next Item Name]
DESC: [Description]
---

Example:
ITEM: Kurta
DESC: Navy blue cotton kurta with mandarin collar, long sleeves, subtle white embroidery along the placket, straight cut, knee-length
---
ITEM: Churidar
DESC: White cotton churidar pants, tight fit, gathered at ankles, plain solid color
---
ITEM: Shoes
DESC: Brown leather formal shoes with laces, oxford style, polished finish
---

Now analyze the image and list ALL visible clothing items with their EXACT colors.
''';
