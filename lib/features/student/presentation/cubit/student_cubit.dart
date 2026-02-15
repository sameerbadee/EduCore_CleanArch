import 'package:educore_cleanarch/features/student/domain/entities/student_entity.dart';
import 'package:educore_cleanarch/features/student/domain/usecases/get_all_students.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class StudentState extends Equatable {
  const StudentState();
  @override
  List<Object> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<StudentEntity> students;
  const StudentLoaded(this.students);
}

class StudentError extends StudentState {
  final String message;
  const StudentError(this.message);
}

class StudentCubit extends Cubit<StudentState> {
  final GetAllStudentsUseCase getAllStudents;

  StudentCubit({required this.getAllStudents}) : super(StudentInitial());

  Future<void> getStudents() async {
    emit(StudentLoading());

    final result = await getAllStudents();

    result.fold(
      (failure) => emit(const StudentError("Error fetching data")),
      (students) => emit(StudentLoaded(students)),
    );
  }
}
