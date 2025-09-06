import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReplyLoader extends StatelessWidget {
  const ReplyLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Getting reply ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SpinKitThreeBounce(
            color: Theme.of(context).colorScheme.onSurface,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
