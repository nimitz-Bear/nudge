import 'package:flutter/material.dart';
import 'package:nudge/providers/user_provider.dart';
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
                MyButton(
                    onTap: () => UserProvider().signUserIn(
                        context, emailController.text, passwordController.text),
                    text: "Sign in"),

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
                    //gmail
                    ImageAndTextButton(
                      onTap: () => UserProvider().siginInWithGoogle(),
                      buttonText: "Continue with Google",
                      imageFilePath: 'lib/images/google.png',
                    ),
                    const SizedBox(height: 10),
                    //apple
                    ImageAndTextButton(
                      onTap: () {},
                      buttonText: "Continue with Apple",
                      imageFilePath: 'lib/images/apple.png',
                    ),
                  ],
                ),

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
