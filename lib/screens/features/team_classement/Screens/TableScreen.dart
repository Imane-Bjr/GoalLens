import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class TableScreen extends StatefulWidget {
  final String code;

  const TableScreen({super.key, required this.code});

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  List<dynamic> _table = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    getTable();
  }

  Future<void> getTable() async {
    final response = await http.get(
      Uri.parse(
          'http://api.football-data.org/v4/competitions/${widget.code}/standings'),
      headers: {'X-Auth-Token': 'b27f31c9ecbc428f9a60915a97b3669d'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> table = data['standings'][0]['table'];
      setState(() {
        _table = table;
      });
    } else {
      throw Exception('Failed to load standings');
    }
  }

  Widget buildTable() {
    List<Widget> teams = _table.map<Widget>((team) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    '${team['position'] ?? 'N/A'} - ',
                    style: const TextStyle(color: Colors.black), // Set to black
                  ),
                  Row(
                    children: [
                      SvgPicture.network(
                        team['team']['crestUrl'] ?? '',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        (team['team']['name'] ?? 'Unknown Team')
                                    .toString()
                                    .length >
                                11
                            ? '${team['team']['name'].toString().substring(0, 11)}...'
                            : team['team']['name'] ?? 'Unknown Team',
                        style: const TextStyle(color: Colors.black), // Set to black
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    team['playedGames']?.toString() ?? '0',
                    style: const TextStyle(color: Colors.black), // Set to black
                  ),
                  Text(
                    team['won']?.toString() ?? '0',
                    style: const TextStyle(color: Colors.black), // Set to black
                  ),
                  Text(
                    team['draw']?.toString() ?? '0',
                    style: const TextStyle(color: Colors.black), // Set to black
                  ),
                  Text(
                    team['lost']?.toString() ?? '0',
                    style: const TextStyle(color: Colors.black), // Set to black
                  ),
                  Text(
                    team['goalDifference']?.toString() ?? '0',
                    style: const TextStyle(color: Colors.black), // Set to black
                  ),
                  Text(
                    team['points']?.toString() ?? '0',
                    style: const TextStyle(color: Colors.black), // Set to black
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();

    return Column(children: teams);
  }

  @override
  Widget build(BuildContext context) {
    return _table.isEmpty
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              leading: IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/HomeScreen');
                },
              ),
              title: const Text('Football Standings'),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(children: [
                          Text('Pos',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900])),
                          const SizedBox(width: 20),
                          Text('Club',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900]))
                        ])),
                        Expanded(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              Text('PL',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900])),
                              Text('W',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900])),
                              Text('D',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900])),
                              Text('L',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900])),
                              Text('GD',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900])),
                              Text('Pts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900]))
                            ])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTable(),
                ],
              ),
            ),
          );
  }
}
