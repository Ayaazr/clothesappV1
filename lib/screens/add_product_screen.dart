import 'package:clothes_app/models/clothes.dart';
import 'package:clothes_app/services/clothes_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ClothesService _clothesService = ClothesService();

  // Variables to store form input
  String _productName = '';
  String _description = '';
  double _price = 0.0;
  String _category = 'Men';
  String _imageUrl = '';

  // StreamController to manage loading state
  final StreamController<bool> _loadingController = StreamController<bool>();

  void _addProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Show loading spinner while adding product
      _loadingController.sink.add(true);

      // Generate a unique ID for the product, for example using a random ID or UUID
      String id = DateTime.now().millisecondsSinceEpoch.toString(); // Example ID

      // Create a Clothes object with the form values
      Clothes newClothes = Clothes(
        id: id,
        name: _productName,
        price: _price,
        description: _description,
        imageUrl: _imageUrl,
        category: _category,
      );

      // Call the service to add the product
      bool success = await _clothesService.addClothes(newClothes);

      if (success) {
        // Product added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
      
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add product')),
        );
      }

      // Stop loading
      _loadingController.sink.add(false);
    }
  }

  @override
  void dispose() {
    _loadingController.close(); // Close StreamController when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Product Name Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product name';
                }
                return null;
              },
              onSaved: (value) {
                _productName = value!;
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (value) {
                _description = value!;
              },
            ),
            const SizedBox(height: 16),

            // Price Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
              onSaved: (value) {
                _price = double.parse(value!);
              },
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: ['Men', 'Women', 'Kids', 'Accessories']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
              onSaved: (value) {
                _category = value!;
              },
            ),
            const SizedBox(height: 16),

            // Image URL Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                _imageUrl = value!;
              },
            ),
            const SizedBox(height: 16),

            // StreamBuilder to handle loading state
            StreamBuilder<bool>(
              stream: _loadingController.stream,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ElevatedButton(
                    onPressed: _addProduct,
                    child: const Text('Add Product'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
