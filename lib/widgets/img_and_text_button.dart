import 'package:flutter/material.dart';

class ImageAndTextButton extends StatelessWidget {
  final void Function()? onTap;
  final String buttonText;
  final String imageFilePath;

  const ImageAndTextButton(
      {super.key,
      required this.onTap,
      required this.buttonText,
      required this.imageFilePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(width: 10),
              Image.asset(imageFilePath, width: 40),
            ],
          ),
        ),
      ),
    );
  }
}
