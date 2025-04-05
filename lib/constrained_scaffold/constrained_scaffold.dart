import 'package:flutter/material.dart';

class ConstrainedScaffold extends StatelessWidget {

  final Widget body;
  final Color? backgroundColor;

  const ConstrainedScaffold({super.key, required this.body, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              maxWidth: 430
          ),
          child: body,
        ),
      ),
    );
  }
}
