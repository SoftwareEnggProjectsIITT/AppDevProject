import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/feed_card.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final dbRef = FirebaseDatabase.instance.ref("posts");
  List<Map<dynamic, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();

    // Listen for changes in /posts
    dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        // Convert to List<Map>
        final tempPosts = <Map<dynamic, dynamic>>[];
        data.forEach((key, value) {
          tempPosts.add({"id": key, ...Map<String, dynamic>.from(value)});
        });
        setState(() {
          posts = tempPosts;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("LegalEase", style: Theme.of(context).textTheme.headlineLarge),
          Text("Welcome to LegalEase, your trusted companion in navigating the complexities of legal documents.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(post["title"] ?? "No Title"),
                  subtitle: Text(post["body"] ?? ""),
                  trailing: Text(post["author"] ?? ""),
                ),
              );
            },
          ),
        ],
      )
    );
  }
}
