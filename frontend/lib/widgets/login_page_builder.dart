import 'package:flutter/material.dart';

class LoginPageBuilder extends StatefulWidget {
  const LoginPageBuilder({
    super.key,
    required this.isLoading,
    required this.handleSignIn,
  });

  final bool isLoading;
  final void Function() handleSignIn;

  @override
  State<LoginPageBuilder> createState() => _LoginPageBuilderState();
}

class _LoginPageBuilderState extends State<LoginPageBuilder> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    "assets/images/login1.png",
    "assets/images/login2.png",
    "assets/images/login3.png",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Fullscreen PageView with images
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 10,
                  width: _currentPage == index ? 25 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              onPressed: widget.handleSignIn,
              child: widget.isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_logo.png',
                          height: 30,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Sign in with Google",
                          style: TextStyle(fontSize: 17.5),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
