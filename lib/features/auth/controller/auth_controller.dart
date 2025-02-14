import 'package:appwrite/models.dart';
import 'package:devconnect/apis/auth_api.dart';
import 'package:devconnect/apis/user_api.dart';
import 'package:devconnect/core/utils.dart';
import 'package:devconnect/features/auth/view/signin_view.dart';
import 'package:devconnect/features/auth/view/signup_view.dart';
import 'package:devconnect/features/home/view/home_view.dart';
import 'package:devconnect/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  final current = await authController.currentUser();
  if (current == null) {
    // Handle the case when there's no current user
    return null;
  } else {
    final currentUserId = current.$id;
    return await ref.watch(userDetailsProvider(currentUserId).future);
  }
});

final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  debugPrint("Inside userDetailsProvider - Fetching data for UID: $uid");

  final authController = ref.read(authControllerProvider.notifier);
  final userData = await authController.getUserData(uid);
  debugPrint("Fetched user details: ${userData.toString()}");
  return userData;
});

final currentUserAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  final user = await authController.currentUser();

  debugPrint("Current User: $user");

  return user;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  //state = isLoading
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) async {
      UserModel userModel = UserModel(
        email: email,
        name: getNameFromEmail(email),
        followers: [],
        following: [],
        profilePic: '',
        bannerPic: '',
        bio: '',
        uid: r.$id,
        isDev: false,
      );
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) {
        showSnackBar(context, l.message);
      }, (r) {
        showSnackBar(context, "Account created successfully");
        Navigator.push(context, SignInView.route());
      });
    });
  }

  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signIn(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, "Logged in successfully");
      Navigator.pushReplacement(context, HomeView.route());
    });
  }

  Future<UserModel> getUserData(String uid) async {
    debugPrint("Fetching data for UID: $uid");

    final doc = await _userAPI.getUserData(uid);

    debugPrint("Fetched user data: ${doc.data}");

    return UserModel.fromMap(doc.data);
  }

  void logout(BuildContext context) async {
    
    final res = await _authAPI.logout();
    res.fold((l) {
      debugPrint("Error logging out: ${l.message}");
    }, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpView.route(),
        (route) => false,
      );
    });
  }
}
