import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nudge/widgets/my_button.dart';
import 'package:nudge/widgets/my_textfield.dart';

import '../services/auth_service.dart';
import '../widgets/img_and_text_button.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(message));
        });
  }

  void signUserUp() async {
    // check fi confirmed password is right
    if (passwordController.text != passwordConfirmController.text) {
      showErrorMessage("passowrds don't match");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD3D3D3),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //appbar with "Nudge?"

                //logo
                const SizedBox(height: 30),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 50),

                //"Log in"
                const Text('Create an account'),
                const SizedBox(height: 25),

                //email textfield
                MyTextfield(
                    controller: emailController,
                    hintText: "Enter your email address",
                    obscureText: false),

                //password textfield
                MyTextfield(
                    controller: passwordController,
                    hintText: "Enter your password",
                    obscureText: true),

                //confirm password textfield
                MyTextfield(
                    controller: passwordConfirmController,
                    hintText: "Confirm your password",
                    obscureText: true),
                //Continue with email button
                const SizedBox(height: 25),
                MyButton(onTap: signUserUp, text: "Sign up"),

                const SizedBox(height: 25),

                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Or Continue with"),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset('lib/images/google.png', height: 40),
                    ImageAndTextButton(
                      onTap: () => AuthService().siginInWithGoogle(),
                      buttonText: "Continue with Google",
                      imageFilePath: 'lib/images/google.png',
                    ),

                    const SizedBox(height: 10),
                    // Image.asset('lib/images/apple.png', height: 40)
                    ImageAndTextButton(
                      onTap: widget.onTap,
                      buttonText: "Continue with Apple",
                      imageFilePath: 'lib/images/apple.png',
                    ),
                  ],
                ),

                //apple

                //gmail
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Alredy a member?"),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Sign in",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
