import 'package:hive/hive.dart';
import '../models/student_model.dart';

abstract class StudentLocalDataSource {
  Future<List<StudentModel>> getCachedStudents();
  Future<void> cacheStudents(List<StudentModel> students);
  Future<void> addStudent(StudentModel student);
}

const String kStudentBoxString = 'student_box';

class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  final Box<StudentModel> studentBox;

  StudentLocalDataSourceImpl({required this.studentBox});

  @override
  Future<List<StudentModel>> getCachedStudents() async {
    return studentBox.values.toList();
  }

  @override
  Future<void> cacheStudents(List<StudentModel> students) async {
    await studentBox.clear();
    await studentBox.addAll(students);
  }

  @override
  Future<void> addStudent(StudentModel student) async {
    await studentBox.add(student);
  }
}
