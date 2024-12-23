import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Example categories and subcategories
  final Map<String, Map<String, List<String>>> categories = {
    'Cars': {
      'Sports Cars': ['Sports Car', 'Classic Ford'],
      'Pickup': ['Ford Pickup'],
      'Luxury': ['Vintage Jaguar'],
    },
    'Electronics': {
      'Phones': ['Phone'],
      'Laptops': ['Laptop'],
      'Accessories': ['Headphones'],
    },
  };

  // Example products data
  final List<Map<String, String>> products = [
    {
      'name': 'Sports Car',
      'price': 'Rp52.000',
      'stock': 'Stock 50 | Sold 4',
      'category': 'Cars',
      'subcategory': 'Sports Cars',
      'image': 'https://cdn.pixabay.com/photo/2020/09/06/07/37/car-5548242_1280.jpg',
    },
    {
      'name': 'Ford Pickup',
      'price': 'Rp15.000',
      'stock': 'Stock 48 | Sold 2',
      'category': 'Cars',
      'subcategory': 'Pickup',
      'image': 'https://cdn.pixabay.com/photo/2020/06/13/19/21/ford-f150-5295540_1280.jpg',
    },
    {
      'name': 'Classic Ford',
      'price': 'Rp60.000',
      'stock': 'Stock 1 | Sold 4',
      'category': 'Cars',
      'subcategory': 'Luxury',
      'image': 'https://cdn.pixabay.com/photo/2020/04/16/23/14/car-5052623_1280.jpg',
    },

    {
      'name': 'Smartphone',
      'price': 'Rp5.000.000',
      'stock': 'Stock 100 | Sold 50',
      'category': 'Electronics',
      'subcategory': 'Phones',
      'image': 'https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    },
    {
      'name': 'Laptop',
      'price': 'Rp10.000.000',
      'stock': 'Stock 20 | Sold 12',
      'category': 'Electronics',
      'subcategory': 'Laptops',
      'image': 'https://images.pexels.com/photos/812264/pexels-photo-812264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    },
    {
      'name': 'Headphones',
      'price': 'Rp1.500.000',
      'stock': 'Stock 75 | Sold 30',
      'category': 'Electronics',
      'subcategory': 'Accessories',
      'image': 'https://images.pexels.com/photos/1649771/pexels-photo-1649771.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    },
  ];

  String selectedCategory = 'Cars';  // Default selected category
  String selectedSubcategory = 'Sports Cars';  // Default selected subcategory

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productStockController = TextEditingController();
  TextEditingController productImageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Filter products based on the selected category and subcategory
    final filteredProducts = products
        .where((product) =>
    product['category'] == selectedCategory &&
        product['subcategory'] == selectedSubcategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newCategory) {
                setState(() {
                  selectedCategory = newCategory!;
                  selectedSubcategory = categories[selectedCategory]!.keys.first;
                });
              },
              items: categories.keys.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Subcategory Dropdown
            DropdownButton<String>(
              value: selectedSubcategory,
              onChanged: (String? newSubcategory) {
                setState(() {
                  selectedSubcategory = newSubcategory!;
                });
              },
              items: categories[selectedCategory]!.keys.map<DropdownMenuItem<String>>((String subcategory) {
                return DropdownMenuItem<String>(
                  value: subcategory,
                  child: Text(subcategory),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Add Product Button
            ElevatedButton(
              onPressed: () {
                _showAddProductDialog(context);
              },
              child: Text("Add Product"),
            ),
            SizedBox(height: 20),

            // Product Grid
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            image: DecorationImage(
                              image: NetworkImage(filteredProducts[index]['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredProducts[index]['name']!,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 0),
                              Text(
                                filteredProducts[index]['stock']!,
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              SizedBox(height: 0),
                              Text(
                                filteredProducts[index]['price']!,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
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
      ),
    );
  }

  // Function to show the Add Product dialog
  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: "Product Name"),
              ),
              TextField(
                controller: productPriceController,
                decoration: InputDecoration(labelText: "Price"),
              ),
              TextField(
                controller: productStockController,
                decoration: InputDecoration(labelText: "Stock"),
              ),
              TextField(
                controller: productImageController,
                decoration: InputDecoration(labelText: "Image URL"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _addProduct();
                Navigator.pop(context);
              },
              child: Text("Add Product"),
            ),
          ],
        );
      },
    );
  }

  // Function to add the product to the list
  void _addProduct() {
    setState(() {
      products.add({
        'name': productNameController.text,
        'price': productPriceController.text,
        'stock': productStockController.text,
        'category': selectedCategory,
        'subcategory': selectedSubcategory,
        'image': productImageController.text,
      });
      // Clear the text fields after adding the product
      productNameController.clear();
      productPriceController.clear();
      productStockController.clear();
      productImageController.clear();
    });
  }
}
