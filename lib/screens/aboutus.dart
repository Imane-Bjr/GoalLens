import 'package:flutter/material.dart';
import 'home_page.dart'; // Ensure this is correctly imported

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _features = [
    {
      'title': 'About Us',
      'description':
          'Learn more about our mission, vision, and the team behind the app. Our goal is to provide you with cutting-edge tools to enhance your experience and help you achieve more.',
    },
    {
      'title': 'Team Classement',
      'description':
          'Stay up-to-date with real-time rankings of  teams. Track performances, monitor progress, and discover the leaders in your field with our intuitive ranking system.',
    },
    {
      'title': 'Player Detection',
      'description':
          'Our advanced player detection technology makes it easier than ever to identify players in any setting. With just a click, you can automatically recognize and track individual players in real time.',
    },
    {
      'title': 'Video Processing',
      'description':
          'Seamlessly process and analyze videos with our powerful tools. Whether you’re editing, detecting, or enhancing content, our platform integrates smoothly with other systems to elevate your workflow.',
    },
  ];

  void _goToPage(int page) {
    if (page >= 0 && page < _features.length) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/background2.jpg',
            fit: BoxFit.cover,
          ),
          // Home Icon Button
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.home,
                  color: Colors.white, size: 40), // Bigger icon
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              tooltip: 'Go to Home', // Adds accessibility hint
            ),
          ),
          // Content
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final feature = _features[index];
              return _buildFeaturePage(
                title: feature['title']!,
                description: feature['description']!,
              );
            },
          ),
          // Navigation Buttons
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 0
                      ? () => _goToPage(_currentPage - 1)
                      : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _currentPage < _features.length - 1
                      ? () => _goToPage(_currentPage + 1)
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePage({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
