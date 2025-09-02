import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SpinKitThreeBounce(
          color: Colors.grey,
          size: 20.0,
        ),
      ],
    );
  }
}
