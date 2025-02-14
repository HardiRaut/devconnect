import 'package:devconnect/features/auth/controller/auth_controller.dart';
import 'package:devconnect/features/auth/view/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class SignInView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignInView(),
      );
  const SignInView({super.key});

  @override
  ConsumerState<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  Future<void> onSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
       ref.read(authControllerProvider.notifier).signIn(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in successful!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          width: 300,
                          child: RiveAnimation.asset(
                            'assets/login.riv',
                            fit: BoxFit.fitHeight,
                            stateMachines: const ['Login Machine'],
                            onInit: (artboard) {
                              controller = StateMachineController.fromArtboard(
                                  artboard, 'Login Machine');
                              if (controller == null) return;
                              artboard.addController(controller!);
                              isChecking = controller?.findInput("isChecking");
                              numLook = controller?.findInput("numLook");
                              isHandsUp = controller?.findInput("isHandsUp");
                              trigSuccess = controller?.findInput("trigSuccess");
                              trigFail = controller?.findInput("trigFail");
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 39, 37, 37),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 20, top: 20),
                            child: Column(
                              children: [
                                TextField(
                                  focusNode: emailFocusNode,
                                  controller: emailController,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.email),
                                    hintText: 'Enter email',
                                    label: const Text('Email'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    numLook?.change(value.length.toDouble());
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  focusNode: passwordFocusNode,
                                  controller: passwordController,
                                  obscureText: !isPasswordVisible,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.password),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                    hintText: 'Enter password',
                                    label: const Text('Password'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                    const SizedBox(width: 5),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SignUpView(),
                                          ),(route) => false
                                        );
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: onSignIn,
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}