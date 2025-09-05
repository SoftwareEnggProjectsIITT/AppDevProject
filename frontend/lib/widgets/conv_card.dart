import 'package:flutter/material.dart';

class ConvCard extends StatelessWidget {
  const ConvCard({super.key, required this.title, required this.showChat});

  final String title;
  final void Function() showChat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: InkWell(
          onTap: showChat,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
