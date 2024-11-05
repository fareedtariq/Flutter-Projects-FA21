// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:tms_app/cubit/app_states.dart';
import 'package:tms_app/modules/archive_task/archive_task_screen.dart';
import 'package:tms_app/modules/done_task/done_task_screen.dart';
import 'package:tms_app/modules/new_task/new_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  // For image
  File? imageFile;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      // print(imageFile);
      // print(pickedImage);
    } else {
      print('Not found image');
    }
    emit(UploadeImage());
  }

  // For bottom navigation
  int currentPage = 0;

  // List of screens
  List<Widget> screensPage = [
    const NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchiveTaskScreen(),
  ];

  List<String> titleScreen = [
    'New Screen',
    'Done Screen',
    'Archive Screen',
  ];

  // Change in the bottom navigation bar
  void changeBottomNavBar(int index) {
    currentPage = index; // Update the current page index
    emit(AppBottomNavBarChangeState()); // Emit the change state
  }

  // Change in the icon and the bottom sheet state
  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShowed,
    required IconData icon,
  }) {
    isBottomSheetShow = isShowed;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  // --------------Database---------------//

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  // Initialize the database
  late Database database;

  // Create the database
  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created new !!');
        // title, time, date, status
        database
            .execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT, time TEXT, date TEXT, status TEXT, image VARCHAR)')
            .then((value) {
          print('Table created ');
        }).catchError((error) {
          print('Error when creating table :> ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataBase(database);
        print('Open database new ??');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseStates());
    });
  }

  // Insert into the database
  insertDataBase({
    required String title,
    required String time,
    required String date,
    required String description,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
          'INSERT INTO Tasks(title, description, time, date, status, image) VALUES("$title", "$description", "$time", "$date", "new", "${imageFile.toString()}")')
          .then((value) {
        print('Insert successfully $value');
        emit(AppInsertDatabaseStates());
        // Get the database
        getDataBase(database);
      }).catchError((error) {
        print('Error when inserting new record :> ${error.toString()}');
      });
    });
  }

  void getDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    // ------------------list of elements-----------------//
    emit(AppGetLoadingDatabaseStates());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      print(' Data :=> $value');
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDatabaseStates());
    });
  }

  // Update the function
  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataBase(database);
      emit(AppUpdateDatabaseStates());
    });
  }

  // To delete from database by the id
  void deleteDatabase({required int id}) {
    database.rawDelete(
      'DELETE FROM Tasks WHERE id= ?',
      [id],
    ).then((value) {
      getDataBase(database);
      emit(AppDeleteDatabaseStates());
    });
  }
}
