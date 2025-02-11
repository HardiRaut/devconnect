import 'package:devconnect/core/core.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = Future<Either<Failure, void>>;