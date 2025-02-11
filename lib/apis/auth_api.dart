import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:devconnect/core/core.dart';
import 'package:devconnect/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authAPIProvider = Provider<AuthAPI>((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

abstract class IAuthAPI {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });

  FutureEither<Session> signIn({
    required String email,
    required String password,
  });

  Future<User?> currentUserAccount();
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
      
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(user);
    } on AppwriteException catch (e) {
      return left(Failure(
        e.message ?? 'An error occurred',
        StackTrace.current,
      ));
    } catch (e) {
      return left(Failure(
        e.toString(),
        StackTrace.current,
      ));
    }
  }

  @override
  FutureEither<Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e) {
      return left(Failure(
        e.message ?? 'An error occurred',
        StackTrace.current,
      ));
    } catch (e) {
      return left(Failure(
        e.toString(),
        StackTrace.current,
      ));
    }
  }
}
