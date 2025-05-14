import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productivity_tool_flutter/utils/routes/routes_name.dart';

import '../Client-Anonymous/ui-helper/loadingAnimation.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  Widget _buildGradientCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required List<Color> gradientColors,
    required double cardHeight,
    required double cardFontSize,
    required double iconSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.6),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: cardFontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Get.put(DialogAlertController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3E8E7E),
                  Color(0xFF5C4D91),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.2),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 12.0), // Add spacing between profile picture and app icon

              // App Icon in the Title Section
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60.0),
                    child: Image.asset(
                      'assets/icons/app-bar-logo-background.png', // Replace this path with your app icon's path
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.signup);
                },
                icon: const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white70,
                  size: 30,
                )),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2B5876),
                  Color(0xFF4E4376),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CustomPaint(
              painter: RadialGlowPainter(),
            ),
          ),

          // Responsive Grid
          LayoutBuilder(
            builder: (context, constraints) {
              double cardHeight = constraints.maxHeight * 0.18;
              double cardFontSize = constraints.maxWidth < 400 ? 16 : 18;
              double iconSize = constraints.maxWidth < 400 ? 34 : 40;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13),
                child: GridView.count(
                  crossAxisCount: size.width < 600 ? 2 : 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildGradientCard(
                      title: 'Notepad',
                      icon: Icons.create_outlined,
                      onTap: () => Navigator.pushNamed(context, RoutesName.notepadScreen),
                      gradientColors: [Color(0xFFee0979), Color(0xFFff6a00)],
                      cardHeight: cardHeight,
                      cardFontSize: cardFontSize,
                      iconSize: iconSize,
                    ),
                    _buildGradientCard(
                      title: 'To Do',
                      icon: Icons.checklist_rounded,
                      onTap: () => Navigator.pushNamed(context, RoutesName.todoScreen),
                      gradientColors: [Color(0xFF56ab2f), Color(0xFFa8e063)],
                      cardHeight: cardHeight,
                      cardFontSize: cardFontSize,
                      iconSize: iconSize,
                    ),
                    _buildGradientCard(
                      title: 'Manage Tasks',
                      icon: Icons.fact_check_rounded,
                      onTap: () => Navigator.pushNamed(context, RoutesName.manageNotePriorityScreen),
                      gradientColors: [Color(0xFF7b4397), Color(0xFFdc2430)],
                      cardHeight: cardHeight,
                      cardFontSize: cardFontSize,
                      iconSize: iconSize,
                    ),
                    _buildGradientCard(
                      title: 'Schedule',
                      icon: Icons.calendar_today_rounded,
                      onTap: () => Navigator.pushNamed(context, RoutesName.scheduleScreen),
                      gradientColors: [Color(0xFF2980b9), Color(0xFF6dd5fa)],
                      cardHeight: cardHeight,
                      cardFontSize: cardFontSize,
                      iconSize: iconSize,
                    ),
                    _buildGradientCard(
                      title: 'Ask AI',
                      icon: Icons.lightbulb,
                      onTap: () => Navigator.pushNamed(context, RoutesName.chatScreen),
                      gradientColors: [Color(0xFFf12711), Color(0xFFf5af19)],
                      cardHeight: cardHeight,
                      cardFontSize: cardFontSize,
                      iconSize: iconSize,
                    ),
                    _buildGradientCard(
                      title: 'Promo Timer',
                      icon: Icons.timer_rounded,
                      onTap: () => Navigator.pushNamed(context, RoutesName.timer),
                      gradientColors: [Colors.purpleAccent, Colors.cyanAccent],
                      cardHeight: cardHeight,
                      cardFontSize: cardFontSize,
                      iconSize: iconSize,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RadialGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6A5ACD).withOpacity(0.3),
          Colors.transparent,
        ],
        radius: 0.5,
        center: Alignment.center,
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
