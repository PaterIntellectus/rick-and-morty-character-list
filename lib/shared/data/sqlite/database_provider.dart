// import 'package:flutter/widgets.dart';
// import 'package:sqflite/sqlite_api.dart';

// class DatabaseProvider extends InheritedWidget {
//   const DatabaseProvider({
//     super.key,
//     required super.child,
//     required this.database,
//   });

//   final Database database;

//   static Database? maybeOf(BuildContext context) =>
//       context.dependOnInheritedWidgetOfExactType<DatabaseProvider>()?.database;

//   static Database of(BuildContext context) {
//     final database = maybeOf(context);
//     assert(database != null, 'Database не найден');
//     return database!;
//   }

//   @override
//   bool updateShouldNotify(DatabaseProvider oldWidget) =>
//       database != oldWidget.database;
// }
