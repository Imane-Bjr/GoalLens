import 'package:flutter/material.dart';
import 'TableScreen.dart';
import '/screens/features/team_classement/Widgets/LeagueContainer.dart';
import '/screens/features/Welcome.dart'; // Import the WelcomeScreen widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff32a852), // Green
                Color(0xffffffff), // White
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Top navigation bar with Home icon
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, color: Colors.white),
                        onPressed: () {
                          // Navigate to the WelcomeScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WelcomeScreen(), // Updated here
                            ),
                          );
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Competitions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 238, 238, 238),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 48), // Placeholder to balance Home icon
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'assets/images/pl.png'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TableScreen(code: 'PL'),
                              ));
                        },
                      ),
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'assets/images/laliga.png'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TableScreen(code: 'PD'),
                              ));
                        },
                      ),
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'assets/images/bundesliga.png'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TableScreen(code: 'BL1'),
                              ));
                        },
                      ),
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'assets/images/seria.png'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TableScreen(code: 'SA'),
                              ));
                        },
                      ),
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'assets/images/ligue1.png'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TableScreen(code: 'FL1'),
                              ));
                        },
                      ),
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'assets/images/nos.png'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TableScreen(code: 'PPL'),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
