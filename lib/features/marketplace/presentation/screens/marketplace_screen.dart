import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class _Product {
  final String name;
  final String price;
  final String category;
  const _Product(this.name, this.price, this.category);
}

const _categories = ['All', 'Seeds', 'Fertilizer', 'Feeds', 'Chemicals', 'Tools', 'Machinery', 'Produce'];

const _products = [
  _Product('Hybrid Maize Seed (5kg)', 'UGX 45,000', 'Seeds'),
  _Product('NPK Fertilizer (50kg)', 'UGX 120,000', 'Fertilizer'),
  _Product('Matooke Bunch (Fresh)', 'UGX 15,000', 'Produce'),
  _Product('Knapsack Sprayer 16L', 'UGX 85,000', 'Tools'),
  _Product('Coffee Beans (Grade A)', 'UGX 9,500/kg', 'Produce'),
  _Product('Layers Feed (70kg)', 'UGX 130,000', 'Feeds'),
];

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? _products
        : _products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search crops, inputs, services…',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  selectedColor: AppColors.primaryGreen.withOpacity(0.15),
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No products in this category yet.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, i) {
                      final p = filtered[i];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_rounded, color: AppColors.textSecondary, size: 32),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(p.price, style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w700, fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
