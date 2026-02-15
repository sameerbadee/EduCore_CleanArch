import 'package:educore_cleanarch/features/student/presentation/cubit/student_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students Sync App")),
      body: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentLoaded) {
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text(student.email),
                  trailing: Icon(
                    student.isSynced ? Icons.cloud_done : Icons.cloud_off,
                    color: student.isSynced ? Colors.green : Colors.grey,
                  ),
                );
              },
            );
          } else if (state is StudentError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Press button to fetch"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<StudentCubit>().getStudents(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
