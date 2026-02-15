import '../models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<List<StudentModel>> getAllStudents();
  Future<void> addStudent(StudentModel student);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  @override
  Future<List<StudentModel>> getAllStudents() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      const StudentModel(
        id: 1,
        name: "Ahmed (Online)",
        email: "ahmed@test.com",
        isSynced: true,
      ),
      const StudentModel(
        id: 2,
        name: "Sara (Online)",
        email: "sara@test.com",
        isSynced: true,
      ),
    ];
  }

  @override
  Future<void> addStudent(StudentModel student) async {
    await Future.delayed(const Duration(seconds: 1));

    return;
  }
}
