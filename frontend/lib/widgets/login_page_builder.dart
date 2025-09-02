import 'package:flutter/material.dart';

class LoginPageBuilder extends StatefulWidget {
  const LoginPageBuilder({super.key});

  @override
  State<LoginPageBuilder> createState() => _LoginPageBuilderState();
}

class _LoginPageBuilderState extends State<LoginPageBuilder> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> _titles = [
    "Welcome to MyApp",
    "Track your progress",
    "Stay connected"
  ];

  final List<String> _descriptions = [
    "This app helps you manage your tasks efficiently.",
    "Visualize your goals and stay motivated.",
    "Sign in with Google and sync across devices."
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _titles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info, size: 120, color: Colors.blueAccent),
                        const SizedBox(height: 30),
                        Text(
                          _titles[index],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _descriptions[index],
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      
            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_titles.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 10,
                  width: _currentPage == index ? 25 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
      
            const SizedBox(height: 40),
          ]
      ),
    );
  }
}