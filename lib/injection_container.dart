import 'package:educore_cleanarch/features/student/data/datasources/student_local_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/network_info.dart';

import 'features/student/data/datasources/student_remote_datasource.dart';
import 'features/student/data/models/student_model.dart';
import 'features/student/data/repositories/student_repository_impl.dart';
import 'features/student/domain/repositories/student_repository.dart';
import 'features/student/domain/usecases/get_all_students.dart';
import 'features/student/presentation/cubit/student_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Student

  sl.registerFactory(() => StudentCubit(getAllStudents: sl()));

  sl.registerLazySingleton(() => GetAllStudentsUseCase(sl()));

  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<StudentLocalDataSource>(
    () => StudentLocalDataSourceImpl(studentBox: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  final box = Hive.box<StudentModel>(kStudentBoxString);
  sl.registerLazySingleton(() => box);

  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
