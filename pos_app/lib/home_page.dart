import 'package:flutter/material.dart';
import 'products_screen.dart';  // Import the ProductsScreen
import 'account_screen.dart';   // Import AccountScreen
import 'transaction_screen.dart'; // Import TransactionScreen
import 'product_stock_report.dart'; // Import ProductStockReportScreen

class HomeScreen extends StatelessWidget {
  // Updated products list with additional Electronics products
  final List<Map<String, String>> products = [
    // Cars category products
    {
      'name': 'Sports Car',
      'price': 'Rp52.000',
      'stock': 'Stock 50 | Sold 4',
      'image': 'https://cdn.pixabay.com/photo/2020/09/06/07/37/car-5548242_1280.jpg',
    },
    {
      'name': 'Ford Pickup',
      'price': 'Rp15.000',
      'stock': 'Stock 48 | Sold 2',
      'image': 'https://cdn.pixabay.com/photo/2020/06/13/19/21/ford-f150-5295540_1280.jpg',
    },
    {
      'name': 'Classic Ford',
      'price': 'Rp60.000',
      'stock': 'Stock 1 | Sold 4',
      'image': 'https://cdn.pixabay.com/photo/2020/04/16/23/14/car-5052623_1280.jpg',
    },
    {
      'name': 'Vintage Jaguar',
      'price': 'Rp10.000.000',
      'stock': 'Stock 1 | Sold 4',
      'image': 'https://cdn.pixabay.com/photo/2016/07/07/20/04/jaguar-xk-150-1503132_1280.jpg',
    },
    // Electronics category products
    {
      'name': 'Smartphone',
      'price': 'Rp5.000.000',
      'stock': 'Stock 100 | Sold 50',
      'image': 'https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    },
    {
      'name': 'Laptop',
      'price': 'Rp10.000.000',
      'stock': 'Stock 20 | Sold 12',
      'image': 'https://images.pexels.com/photos/812264/pexels-photo-812264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    },
    {
      'name': 'Headphones',
      'price': 'Rp1.500.000',
      'stock': 'Stock 75 | Sold 30',
      'image': 'https://images.pexels.com/photos/1649771/pexels-photo-1649771.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    },
  ];

  // Assume these values come from Create Account and Profile Setup screens
  final String userName = 'Fareed';
  final String userEmail = 'fsfsffsf@gmail.com';

  // Placeholder variables for dark mode and theme toggling
  final bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.black),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  userEmail,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.sync, color: Colors.green),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search Products...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 20),

              // Product Grid
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: products.length,
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
                                image: NetworkImage(products[index]['image']!),
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
                                  products[index]['name']!,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  products[index]['stock']!,
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  products[index]['price']!,
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
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Stock Report',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountScreen(
                    name: userName,
                    email: userEmail,
                    isDarkMode: isDarkMode,
                    toggleTheme: (value) {
                      // Handle the dark mode toggle here
                    },
                  ),
                ),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductStockReportScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
