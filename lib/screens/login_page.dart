import 'package:flutter/material.dart';
import 'package:nudge/widgets/my_button.dart';
import 'package:nudge/widgets/my_textfield.dart';

import '../widgets/img_and_text_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD3D3D3),
      body: SafeArea(
        child: Center(
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

              //Continue with email button
              const SizedBox(height: 25),
              MyButton(onTap: signUserIn),

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
                    onTap: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
