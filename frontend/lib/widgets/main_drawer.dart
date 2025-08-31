import 'package:flutter/material.dart';
import 'package:frontend/models/auth.dart';
import 'package:frontend/providers/notifiers.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({super.key});

  final userName = userNotifier.value?.displayName ?? "Guest";
  final userEmail = userNotifier.value?.email ?? "No Email";
  final userImage = userNotifier.value?.photoURL;

  final _auth  = Auth();

  Future<void> _logout(BuildContext context) async {
    showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure about logging out ?'),
        actions: [
          TextButton(onPressed: () {Navigator.pop(ctx);}, child: const Text('Cancel')),
          TextButton(onPressed: () {_auth.signOut();Navigator.pop(ctx);}, child: const Text('Yes')),
        ],
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              padding: EdgeInsetsGeometry.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: userImage != null
                        ? NetworkImage(userImage!)
                        : null,
                    child: userImage == null
                        ? const Icon(Icons.person, size: 45, color: Colors.grey)
                        : null,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userName, style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(userEmail),
                      ],
                    ),
                  ),
                ],
              )
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                'Languages',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                
              },
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
                  fontSize: 20,
                ),
              ),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}