import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardsScreen extends StatelessWidget {
  const LeaderboardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final players = [
      {'name': 'Alice', 'level': 45},
      {'name': 'Bob', 'level': 38},
      {'name': 'Charlie', 'level': 35},
      {'name': 'Diana', 'level': 32},
      {'name': 'Ethan', 'level': 29},
      {'name': 'Fiona', 'level': 27},
      {'name': 'George', 'level': 25},
      {'name': 'Hannah', 'level': 23},
      {'name': 'Ivan', 'level': 21},
      {'name': 'Julia', 'level': 19},
      {'name': 'Kevin', 'level': 17},
      {'name': 'Luna', 'level': 16},
      {'name': 'Marco', 'level': 15},
      {'name': 'Nina', 'level': 14},
      {'name': 'Oscar', 'level': 13},
      {'name': 'Paula', 'level': 12},
      {'name': 'Quinn', 'level': 11},
      {'name': 'Rita', 'level': 10},
      {'name': 'Sam', 'level': 9},
      {'name': 'Tina', 'level': 8},
    ];

    const medalColors = [
      Color(0xFFFFD700),
      Color(0xFFC0C0C0),
      Color(0xFFCD7F32),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/lol1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'LEADERBOARDS',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 22,
                          color: Colors.orange,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 4,
                    ),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      final name = player['name'] as String;
                      final level = player['level'] as int;
                      final isMedal = index < 3;
                      final rankColor = isMedal
                          ? medalColors[index]
                          : Colors.white;

                      return Card(
                        color: const Color.fromARGB(
                          255,
                          74,
                          34,
                          139,
                        ).withOpacity(0.75),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: isMedal
                              ? BorderSide(color: medalColors[index], width: 2)
                              : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 36,
                                child: Text(
                                  '#${index + 1}',
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 12,
                                    color: rankColor == Colors.white
                                        ? const Color.fromARGB(
                                            255,
                                            237,
                                            227,
                                            255,
                                          )
                                        : rankColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color.fromARGB(
                                      221,
                                      253,
                                      247,
                                      247,
                                    ),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Level $level',
                                style: GoogleFonts.rajdhani(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
