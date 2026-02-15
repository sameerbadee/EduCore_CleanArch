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
    // 1. فحص الاتصال بالإنترنت
    if (await networkInfo.isConnected) {
      try {
        // A. يوجد إنترنت: نجلب البيانات من السيرفر
        final remoteStudents = await remoteDataSource.getAllStudents();

        // B. الخطوة الذكية: نحفظ نسخة منها في Hive (Caching) للعمل أوفلاين لاحقاً
        await localDataSource.cacheStudents(remoteStudents);

        return Right(remoteStudents);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        // C. لا يوجد إنترنت: نجلب البيانات من Hive مباشرة
        final localStudents = await localDataSource.getCachedStudents();
        return Right(localStudents);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addStudent(StudentEntity student) async {
    // تحويل الـ Entity إلى Model لنتعامل مع البيانات
    final studentModel = StudentModel.fromEntity(student);

    if (await networkInfo.isConnected) {
      try {
        // A. أونلاين: نرسل للسيرفر + نحفظ محلياً كـ Synced
        await remoteDataSource.addStudent(studentModel);

        // هنا نحفظها في Hive ونقول أنها (isSynced = true)
        // ملاحظة: يمكنك تعديل الموديل ليقبل copyWith لتغيير الحالة، أو حفظها كما هي إذا كان السيرفر يعيد القيمة
        await localDataSource.addStudent(studentModel);

        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        // B. أوفلاين: نحفظ في Hive فقط (لكن يجب أن تكون isSynced = false)
        // بما أننا لم نرسلها للسيرفر، فهي غير متزامنة
        await localDataSource.addStudent(studentModel);

        // هنا مستقبلاً يمكن عمل Background Service ترفع البيانات غير المتزامنة
        return const Right(unit);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }
}
