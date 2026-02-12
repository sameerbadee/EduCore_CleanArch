import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final bool isSynced;
  const StudentEntity({
    required this.id,
    required this.name,
    required this.email,
    this.isSynced = false,
  });

  @override
  List<Object?> get props => [id, name, email, isSynced];
}
