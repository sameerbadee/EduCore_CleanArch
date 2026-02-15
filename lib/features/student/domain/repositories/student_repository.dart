import 'package:dartz/dartz.dart';
import 'package:educore_cleanarch/core/errors/failures.dart';
import '../entities/student_entity.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<StudentEntity>>> getStudents();

  Future<Either<Failure, Unit>> addStudent(StudentEntity student);
}
