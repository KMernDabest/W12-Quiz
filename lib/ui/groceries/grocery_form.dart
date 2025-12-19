import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/grocery.dart';

const uuid = Uuid();

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  // Default settings
  static const defautName = "New grocery";
  static const defaultQuantity = 1;
  static const defaultCategory = GroceryCategory.fruit;

  // Inputs
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  GroceryCategory _selectedCategory = defaultCategory;

  String? _nameError;
  String? _quantityError;

  @override
  void initState() {
    super.initState();

    // Initialize intputs with default settings
    _nameController.text = defautName;
    _quantityController.text = defaultQuantity.toString();
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose the controlers
    _nameController.dispose();
    _quantityController.dispose();
  }

  void onReset() {
    // Will be implemented later - Reset all fields to the initial values
    setState(() {
      _nameController.text = defautName;
      _quantityController.text = defaultQuantity.toString();
      _selectedCategory = defaultCategory;
    });
  }

  void onAdd() {
    // Will be implemented later - Create and return the new grocery
    final enteredName = _nameController.text;
    final enteredQuantityText = _quantityController.text;
    final enteredQuantity = int.tryParse(enteredQuantityText);

    setState(() {
      _nameError = null;
      _quantityError = null;
    });

    bool isValid = true;

    if (enteredName.trim().isEmpty) {
      setState(() {
        _nameError = "Name cannot be empty.";
      });
      isValid = false;
    }

    if (enteredQuantity == null || enteredQuantity <= 0) {
      setState(() {
        _quantityError = "Must be a valid positive number.";
      });
      isValid = false;
    }

    if(!isValid){
      return;
    }

    final newGrocery = Grocery(
      id: uuid.v4(),
      name: enteredName,
      quantity: enteredQuantity!,
      category: _selectedCategory,
    );

    Navigator.of(context).pop(newGrocery);
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              maxLength: 50,
              decoration: InputDecoration(
                label: Text('Name'),
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      label: Text('Quantity'),
                      errorText: _quantityError,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<GroceryCategory>(
                    initialValue: _selectedCategory,
                    items: GroceryCategory.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  color: category.color,
                                ),
                                const SizedBox(width: 8),
                                Text(category.label),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onReset, child: const Text('Reset')),
                ElevatedButton(onPressed: onAdd, child: const Text('Add Item')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}