import 'package:dartz/dartz.dart';
import 'package:educore_cleanarch/core/errors/failures.dart';
import 'package:educore_cleanarch/features/student/domain/entities/student_entity.dart';
import 'package:educore_cleanarch/features/student/domain/repositories/student_repository.dart';

class GetAllStudentsUseCase {
  final StudentRepository repository;

  GetAllStudentsUseCase(this.repository);

  Future<Either<Failure, List<StudentEntity>>> call() async {
    return await repository.getStudents();
  }
}
