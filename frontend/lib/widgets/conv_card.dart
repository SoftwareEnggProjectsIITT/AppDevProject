import 'package:flutter/material.dart';

class ConvCard extends StatelessWidget {
  const ConvCard({super.key, required this.title, required this.category, required this.showChat});

  final String title;
  final String category;
  final void Function() showChat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: InkWell(
          onTap: showChat,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                      const SizedBox(height: 5),
                      Text(category)
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
