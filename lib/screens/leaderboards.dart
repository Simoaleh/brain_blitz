import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardsScreen extends StatelessWidget {
  const LeaderboardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final players = [
      {'name': 'Alice', 'score': 120},
      {'name': 'Bob', 'score': 98},
      {'name': 'Charlie', 'score': 87},
      {'name': 'Diana', 'score': 75},
      {'name': 'Ethan', 'score': 64},
      {'name': 'Fiona', 'score': 61},
      {'name': 'George', 'score': 57},
      {'name': 'Hannah', 'score': 53},
      {'name': 'Ivan', 'score': 49},
      {'name': 'Julia', 'score': 45},
      {'name': 'Kevin', 'score': 42},
      {'name': 'Luna', 'score': 38},
      {'name': 'Marco', 'score': 35},
      {'name': 'Nina', 'score': 30},
      {'name': 'Oscar', 'score': 27},
      {'name': 'Paula', 'score': 24},
      {'name': 'Quinn', 'score': 20},
      {'name': 'Rita', 'score': 17},
      {'name': 'Sam', 'score': 14},
      {'name': 'Tina', 'score': 10},
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 20),
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
                      final score = player['score'] as int;
                      final isMedal = index < 3;
                      final rankColor = isMedal
                          ? medalColors[index]
                          : Colors.white;

                      return Card(
                        color: Colors.white.withOpacity(0.85),
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
                                        ? Colors.deepPurple
                                        : rankColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '$score pts',
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Back to Home',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.pressStart2p(
                          fontSize: 14,
                          color: const Color(0xFF542EA0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
