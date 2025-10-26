const String geminiDetectionPrompt = '''
Analyze this image and identify ALL individual clothing items and accessories worn by the person.

For EACH item detected, provide:
1. Item name (e.g., "Kurta", "Jeans", "Shawl", "Shoes", "Watch", etc.)
2. Detailed description for realistic product image generation including:
   - EXACT color(s) with specific shade names (e.g., "deep navy blue", "charcoal gray", "burgundy red")
   - Material/fabric type (cotton, silk, denim, leather, polyester, wool, etc.)
   - Texture details (smooth, ribbed, woven, knitted, etc.)
   - Pattern (solid, striped, checkered, floral print, geometric, embroidered, etc.)
   - Style and cut (slim fit, loose, tailored, oversized, etc.)
   - Specific design elements (collar type, buttons, zippers, pockets, stitching details)
   - Any unique features (distressing, fading, embellishments, logos)

CRITICAL: Describe colors with maximum accuracy and specificity. Include fabric texture and realistic wear characteristics.

Format your response EXACTLY like this:
ITEM: [Item Name]
DESC: [Ultra-detailed description - start with precise color and shade, then material with texture, pattern, cut, and all visible details]
---
ITEM: [Next Item Name]
DESC: [Description]
---

Example:
ITEM: Denim Jacket
DESC: Medium wash indigo blue denim jacket with slight fading, 100% cotton twill fabric with visible diagonal weave texture, classic trucker style with pointed collar, silver metal buttons, two chest flap pockets with button closure, slightly distressed edges, regular fit with structured shoulders
---
ITEM: White Sneakers
DESC: Crisp white leather low-top sneakers with minimal design, smooth grain leather upper, flat cotton laces, white rubber sole with slight platform, small perforations on toe box for breathability, clean minimalist aesthetic
---
ITEM: Black Watch
DESC: Matte black stainless steel watch with round face, black dial with silver hour markers, black leather strap with visible grain texture, silver buckle clasp, modern minimalist design
---

Now analyze the image and describe ALL visible items with photographic precision and realistic detail.
''';