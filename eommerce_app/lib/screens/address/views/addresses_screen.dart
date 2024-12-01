import 'package:flutter/material.dart';

class AddressBook extends StatelessWidget {
  const AddressBook({super.key});

  final List<Address> addresses = [
    Address(
      name: 'My Home',
      iconData: Icons.home,
      addressLine1: 'Sophi Nowakowska',
      addressLine2: 'Zabiniec 12/222, 31-215 Cracow, Poland',
      phoneNumber: '+79 123 456 789',
      isDefault: true,
    ),
    Address(
      name: 'Office',
      iconData: Icons.work,
      addressLine1: 'Rio Nowakowska',
      addressLine2: 'Zabiniec 12/222, 31-215 Cracow, Poland',
      phoneNumber: '+79 123 456 789',
    ),
    Address(
      name: 'Grandmother\'s Home',
      iconData: Icons.accessibility,
      addressLine1: 'Rio Nowakowska',
      addressLine2: 'Zabiniec 12/222, 31-215 Cracow, Poland',
      phoneNumber: '+79 123 456 789',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final address = addresses[index];
            return Card(
              child: ListTile( 1
                  leading: Icon(address.iconData),
              title: Text(address.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.addressLine1),
                  Text(address.addressLine2),
                  Text(address.phoneNumber),
                ],
              ),
              trailing: address.isDefault
                  ? const Text('Default')
                  : null,
            ),
            );
          },
        ),
      ),
    );
  }
}

class Address {
  final String name;
  final IconData iconData;
  final String addressLine1;
  final String addressLine2;
  final String phoneNumber;
  final bool isDefault;

  Address({
    required this.name,
    required this.iconData,
    required this.addressLine1,
    required this.addressLine2,
    required this.phoneNumber,
    this.isDefault = false,
  });
}
