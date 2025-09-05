import 'package:flutter/material.dart';
import 'package:frontend/models/auth.dart';
import 'package:frontend/providers/notifiers.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({super.key});

  final _auth = Auth();

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure about logging out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(ctx);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userNotifier,
      builder: (context, user, _) {
        final userName = user?.displayName ?? "Guest";
        final userEmail = user?.email ?? "No Email";
        final userImage = user?.photoURL;

        return Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withAlpha(50),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            userImage != null ? NetworkImage(userImage) : null,
                        child: userImage == null
                            ? const Icon(Icons.person,
                                size: 45, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 5),
                            FittedBox(
                              child: Text(
                                userEmail,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20
                    ),
                  ),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
