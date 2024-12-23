import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class ProductStockReportScreen extends StatefulWidget {
  @override
  _ProductStockReportScreenState createState() =>
      _ProductStockReportScreenState();
}

class _ProductStockReportScreenState extends State<ProductStockReportScreen> {
  final List<Map<String, String>> products = [
    {
      'name': 'Sports Car',
      'price': 'Rp52.000',
      'stock': 'Stock 50 | Sold 4',
      'category': 'Cars',
    },
    {
      'name': 'Ford Pickup',
      'price': 'Rp15.000',
      'stock': 'Stock 48 | Sold 2',
      'category': 'Cars',
    },
    {
      'name': 'Classic Ford',
      'price': 'Rp60.000',
      'stock': 'Stock 1 | Sold 4',
      'category': 'Cars',
    },
    {
      'name': 'Vintage Jaguar',
      'price': 'Rp10.000.000',
      'stock': 'Stock 1 | Sold 4',
      'category': 'Cars',
    },
    {
      'name': 'Smartphone',
      'price': 'Rp5.000.000',
      'stock': 'Stock 100 | Sold 50',
      'category': 'Electronics',
    },
    {
      'name': 'Laptop',
      'price': 'Rp10.000.000',
      'stock': 'Stock 20 | Sold 12',
      'category': 'Electronics',
    },
    {
      'name': 'Headphones',
      'price': 'Rp1.500.000',
      'stock': 'Stock 75 | Sold 30',
      'category': 'Electronics',
    },
  ];

  // Path to save the generated PDF
  String? filePath;

  // Function to generate the PDF
  Future<void> generatePdf(List<Map<String, String>> products) async {
    final pdf = pw.Document();

    // Add content to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Product Stock Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Product Name', 'Price', 'Stock', 'Category'],
                data: products.map((product) {
                  return [
                    product['name']!,
                    product['price']!,
                    product['stock']!,
                    product['category']!,
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    // Save the generated PDF file to the device
    final output = await getExternalStorageDirectory(); // Get external storage directory
    final file = File('${output!.path}/product_stock_report.pdf');
    await file.writeAsBytes(await pdf.save());

    setState(() {
      filePath = file.path;  // Save the file path to be used for downloading
    });
  }

  // Function to download the PDF
  Future<void> downloadPdf() async {
    if (filePath != null) {
      // Open the file directly from storage after it is saved
      OpenFile.open(filePath!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No report generated yet! Please generate the report first.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Stock Report'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with instructions
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Generate and download the product stock report in PDF format.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            // Button to generate PDF
            ElevatedButton(
              onPressed: () async {
                await generatePdf(products); // Generate the PDF
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button color
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: Text(
                'Generate PDF Report',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            // Button to download the PDF
            ElevatedButton(
              onPressed: () async {
                await downloadPdf(); // Download the PDF
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color for download
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: Text(
                'Download Report',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            // Display a message if no report is generated yet
            if (filePath == null)
              Text(
                'No report generated yet.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}
