import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/student/data/models/student_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(StudentModelAdapter());

  await Hive.openBox<StudentModel>('student_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text("Database Ready!"))),
    );
  }
}
