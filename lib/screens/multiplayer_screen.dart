import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiplayerScreen extends StatefulWidget {
  const MultiplayerScreen({super.key});

  @override
  State<MultiplayerScreen> createState() => _MultiplayerScreenState();
}

class _MultiplayerScreenState extends State<MultiplayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Demo profile data
  final Map<String, dynamic> _profileData = {
    'username': 'SpellMaster99',
    'totalMatches': 47,
    'wins': 31,
    'losses': 16,
    'rank': 'Silver',
  };

  double get _winRate {
    final total = _profileData['totalMatches'] as int;
    final wins = _profileData['wins'] as int;
    return total == 0 ? 0 : (wins / total) * 100;
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showProfile(BuildContext context) {
    final rank = _profileData['rank'] as String;
    final rankColor = rank == 'Gold'
        ? const Color(0xFFFFD700)
        : rank == 'Silver'
        ? const Color(0xFFC0C0C0)
        : const Color(0xFFCD7F32);

    final rankIcon = rank == 'Gold'
        ? '🥇'
        : rank == 'Silver'
        ? '🥈'
        : '🥉';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: Color(0xFF4A90D9), width: 2),
            left: BorderSide(color: Color(0xFF4A90D9), width: 2),
            right: BorderSide(color: Color(0xFF4A90D9), width: 2),
          ),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90D9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF16213E),
                border: Border.all(color: rankColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: rankColor.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(rankIcon, style: const TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _profileData['username'] as String,
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: rankColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rankColor, width: 1),
              ),
              child: Text(
                rank.toUpperCase(),
                style: GoogleFonts.pressStart2p(color: rankColor, fontSize: 10),
              ),
            ),
            const SizedBox(height: 28),
            // Stats grid
            Row(
              children: [
                _StatCard(
                  label: 'Total Matches',
                  value: _profileData['totalMatches'].toString(),
                  color: const Color(0xFF4A90D9),
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Win Rate',
                  value: '${_winRate.toStringAsFixed(1)}%',
                  color: const Color(0xFF50C878),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatCard(
                  label: 'Wins',
                  value: _profileData['wins'].toString(),
                  color: const Color(0xFF50C878),
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Losses',
                  value: _profileData['losses'].toString(),
                  color: const Color(0xFFE74C3C),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // W/L bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'W / L RATIO',
                  style: GoogleFonts.pressStart2p(
                    color: const Color(0xFF8899AA),
                    fontSize: 8,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      Flexible(
                        flex: _profileData['wins'] as int,
                        child: Container(
                          height: 14,
                          color: const Color(0xFF50C878),
                        ),
                      ),
                      Flexible(
                        flex: _profileData['losses'] as int,
                        child: Container(
                          height: 14,
                          color: const Color(0xFFE74C3C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'W ${_profileData['wins']}',
                      style: GoogleFonts.pressStart2p(
                        color: const Color(0xFF50C878),
                        fontSize: 8,
                      ),
                    ),
                    Text(
                      'L ${_profileData['losses']}',
                      style: GoogleFonts.pressStart2p(
                        color: const Color(0xFFE74C3C),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Background grid pattern
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _GridPainter(),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF4A90D9),
                          size: 20,
                        ),
                      ),
                      Text(
                        'MULTIPLAYER',
                        style: GoogleFonts.pressStart2p(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      // Profile button
                      GestureDetector(
                        onTap: () => _showProfile(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF16213E),
                            border: Border.all(
                              color: const Color(0xFF4A90D9),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF4A90D9),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Globe / arena icon
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  ),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF16213E),
                      border: Border.all(
                        color: const Color(0xFF4A90D9),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A90D9).withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.public,
                      size: 72,
                      color: Color(0xFF4A90D9),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'BATTLE ARENA',
                  style: GoogleFonts.pressStart2p(
                    color: const Color(0xFF4A90D9),
                    fontSize: 14,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Challenge players worldwide',
                  style: GoogleFonts.pressStart2p(
                    color: const Color(0xFF556677),
                    fontSize: 8,
                  ),
                ),

                const Spacer(),

                // Match buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      _MatchButton(
                        label: 'FRIENDS MATCH',
                        icon: Icons.group,
                        primaryColor: const Color(0xFF50C878),
                        onTap: () => _showComingSoon(context, 'Friends Match'),
                      ),
                      const SizedBox(height: 16),
                      _MatchButton(
                        label: 'RANDOM MATCH',
                        icon: Icons.shuffle,
                        primaryColor: const Color(0xFFFF6B35),
                        onTap: () => _showComingSoon(context, 'Random Match'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String mode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF4A90D9)),
        ),
        behavior: SnackBarBehavior.floating,
        content: Text(
          '$mode — Coming Soon!',
          style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 9),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _MatchButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color primaryColor;
  final VoidCallback onTap;

  const _MatchButton({
    required this.label,
    required this.icon,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.pressStart2p(
                color: primaryColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4), width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.pressStart2p(color: color, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.pressStart2p(
                color: const Color(0xFF8899AA),
                fontSize: 7,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A3E).withOpacity(0.5)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}
