import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_app/constant/constant_screen.dart';

import 'package:tms_app/cubit/app_cubit.dart';
import 'package:tms_app/cubit/app_states.dart';

class UpdateScreen extends StatelessWidget {
  final dynamic model;
  const UpdateScreen({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    String nwImage = '';
    String nnnn = '';
    if (model['image'] != null) {
      nwImage = model['image'];
      nnnn = nwImage.substring(8, nwImage.length - 1);
      print("After remove ==> " + nnnn);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${model['title']}'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.archive_outlined),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nnnn != null)
            Container(
              width: double.infinity,
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(23),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: FileImage(File(nnnn)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 40.0,
              //color: Colors.yellow,
              child: Text(
                '${model['title']}',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: double.infinity,
              height: 260.0,
              // color: Colors.green,
              child: Text(
                '${model['description']},',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: color4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.add_alert_outlined,
                    color: color1,
                  ),
                  // the time and the date
                  Text(
                    '${model['time']}' + '  ${model['date']}',
                    style: const TextStyle(
                      color: color1,
                    ),
                  ),
                  const Icon(
                    Icons.more_vert_rounded,
                    color: color1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}