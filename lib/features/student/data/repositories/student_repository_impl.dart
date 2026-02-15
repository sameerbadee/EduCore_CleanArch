import 'package:dartz/dartz.dart';
import 'package:educore_cleanarch/core/errors/failures.dart';
import 'package:educore_cleanarch/core/network/network_info.dart';
import 'package:educore_cleanarch/features/student/data/datasources/student_local_data_source.dart';
import 'package:educore_cleanarch/features/student/data/datasources/student_remote_datasource.dart';
import 'package:educore_cleanarch/features/student/data/models/student_model.dart';
import 'package:educore_cleanarch/features/student/domain/entities/student_entity.dart';
import 'package:educore_cleanarch/features/student/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;
  final StudentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  StudentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<StudentEntity>>> getStudents() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteStudents = await remoteDataSource.getAllStudents();

        await localDataSource.cacheStudents(remoteStudents);

        return Right(remoteStudents);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final localStudents = await localDataSource.getCachedStudents();
        return Right(localStudents);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addStudent(StudentEntity student) async {
    final studentModel = StudentModel.fromEntity(student);

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addStudent(studentModel);

        await localDataSource.addStudent(studentModel);

        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        await localDataSource.addStudent(studentModel);

        return const Right(unit);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }
}
