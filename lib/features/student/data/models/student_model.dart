// ignore_for_file: annotate_overrides, overridden_fields
import 'package:hive/hive.dart';
import '../../domain/entities/student_entity.dart';

part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel extends StudentEntity {
  @override
  @HiveField(0)
  final int id;

  @override
  @HiveField(1)
  final String name;

  @override
  @HiveField(2)
  final String email;

  @override
  @HiveField(3)
  final bool isSynced;

  const StudentModel({
    required this.id,
    required this.name,
    required this.email,
    this.isSynced = false,
  }) : super(id: id, name: name, email: email, isSynced: isSynced);

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      isSynced: entity.isSynced,
    );
  }
}
