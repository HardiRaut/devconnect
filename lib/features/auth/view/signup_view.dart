import 'package:devconnect/features/auth/controller/auth_controller.dart';
import 'package:devconnect/features/auth/view/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignUpView> {
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final TextEditingController confirmPasswordController = TextEditingController();

  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    confirmPasswordFocusNode.addListener(confirmPasswordFocus);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    confirmPasswordFocusNode.removeListener(confirmPasswordFocus);
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  void confirmPasswordFocus() {
    isHandsUp?.change(confirmPasswordFocusNode.hasFocus);
  }

  Future<void> onSignUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      ref.read(authControllerProvider.notifier).signUp(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: $e')),
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
                                  obscureText: true,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.password),
                                    hintText: 'Enter password',
                                    label: const Text('Password'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  focusNode: confirmPasswordFocusNode,
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.password),
                                    hintText: 'Enter confirm password',
                                    label: const Text('Confirm Password'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text(
                                      'Already an user?',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                    const SizedBox(width: 5),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignInView(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: onSignUp,
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Sign Up',
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