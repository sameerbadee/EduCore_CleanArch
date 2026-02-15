import 'package:educore_cleanarch/features/student/data/datasources/student_local_data_source.dart';
import 'package:educore_cleanarch/features/student/presentation/pages/student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/student/data/models/student_model.dart';
import 'features/student/presentation/cubit/student_cubit.dart';
import 'injection_container.dart' as di; // استيراد ملف الحقن

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(StudentModelAdapter());

  await Hive.openBox<StudentModel>(kStudentBoxString);

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<StudentCubit>()..getStudents()),
      ],
      child: const MaterialApp(title: 'EduCore Sync', home: StudentsPage()),
    );
  }
}
