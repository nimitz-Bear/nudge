import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nudge/services/auth_service.dart';
import 'package:nudge/widgets/my_button.dart';
import 'package:nudge/widgets/my_textfield.dart';

import '../widgets/img_and_text_button.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    // try to connect to firebase
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(title: Text(e.code));
          });
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
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 50),

                //"Log in"
                Text('Login', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 25),

                //email textfield
                MyTextfield(
                    controller: emailController,
                    hintText: "Enter your email address",
                    obscureText: false),

                //email textfield
                MyTextfield(
                    controller: passwordController,
                    hintText: "Enter your password",
                    obscureText: true),
                //Continue with email button
                const SizedBox(height: 25),
                MyButton(onTap: signUserIn, text: "Sign in"),

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
                      onTap: () {},
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
                        const Text("Not a member?"),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Register now",
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
