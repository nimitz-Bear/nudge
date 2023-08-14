import 'package:flutter/material.dart';

class ScreenBanner extends StatelessWidget {
  final String backgroundImagePath;
  final Color backgroundColor;
  final Widget child;
  final int height;

  const ScreenBanner(
      {super.key,
      this.backgroundImagePath = "",
      this.backgroundColor = Colors.blueGrey,
      required this.child,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height.toDouble(),
        child: Scaffold(
          body: Container(
            height: height.toDouble(),
            width: MediaQuery.of(context).size.width,
            // color: backgroundColor,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage(backgroundImagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
