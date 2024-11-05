// lib/cubit/app_states.dart

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppLoadingState extends AppStates {}

class AppErrorState extends AppStates {}

class AppBottomNavBarChangeState extends AppStates {} // Added state
class AppCreateDatabaseStates extends AppStates {}
class AppInsertDatabaseStates extends AppStates {}
class AppGetLoadingDatabaseStates extends AppStates {}
class AppGetDatabaseStates extends AppStates {}
class AppUpdateDatabaseStates extends AppStates {}
class AppDeleteDatabaseStates extends AppStates {}
class AppChangeBottomSheetState extends AppStates {}
class UploadeImage extends AppStates {}

