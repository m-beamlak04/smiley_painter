// In-Class Activity 06 — Drawing with Flutter
// Student: Beamlak Mulugeta
// Date: September 30, 2026

import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const DrawingPlayground(),
    );
  }
}

enum FaceType { classic, sleepy, surprised }

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  // Drawing "state" — changing these + setState() triggers shouldRepaint
  double mood = 0.8; // 0.0 sad → 1.0 happy
  FaceType selectedFace = FaceType.classic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter Smiley Lab')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(300, 300),
                painter: SmileyPainter(mood: mood, faceType: selectedFace),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Mood: ${mood.toStringAsFixed(2)}'),
                Slider(
                  value: mood,
                  onChanged: (double v) => setState(() => mood = v),
                ),
                DropdownButton<FaceType>(
                  value: selectedFace,
                  items: FaceType.values.map((face) {
                    return DropdownMenuItem(
                      value: face,
                      child: Text(face.name),
                    );
                  }).toList(),
                  onChanged: (FaceType? value) {
                    if (value != null) {
                      setState(() {
                        selectedFace = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({required this.mood, required this.faceType});

  final double mood;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    // Modules 2–3: add eyes and mouth here. Base every position on size, center, or radius.
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.4;

    Color faceColor;

    if (mood < 0.35) {
      faceColor = Colors.lightBlue;
    } else if (mood <= 0.7) {
      faceColor = Colors.yellow.shade600;
    } else {
      faceColor = Colors.orange;
    }

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);

    final border = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, border);

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.18;
    final eyeDx = radius * 0.35;

    if (faceType == FaceType.sleepy) {
      // Sleepy: closed eyes
      canvas.drawLine(
        Offset(center.dx - eyeDx - 10, eyeY),
        Offset(center.dx - eyeDx + 10, eyeY),
        eyePaint,
      );

      canvas.drawLine(
        Offset(center.dx + eyeDx - 10, eyeY),
        Offset(center.dx + eyeDx + 10, eyeY),
        eyePaint,
      );
    } else {
      // Classic and surprised: round eyes
      double eyeSize = faceType == FaceType.surprised ? 18 : 12;

      canvas.drawCircle(
        Offset(center.dx - eyeDx, eyeY),
        eyeSize,
        eyePaint,
      );

      canvas.drawCircle(
        Offset(center.dx + eyeDx, eyeY),
        eyeSize,
        eyePaint,
      );
    }

    // Mouth
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + radius * 0.15),
      width: radius * 1.0,
      height: radius * (0.4 + mood * 0.5),
    );

    if (faceType == FaceType.surprised) {
      // Surprised: open round mouth
      canvas.drawCircle(
        Offset(center.dx, center.dy + radius * 0.30),
        radius * 0.18,
        Paint()..color = Colors.black87,
      );
    } else if (mood >= 0.5) {
      canvas.drawArc(
        mouthRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    } else {
      final frownRect = mouthRect.translate(0, radius * 0.25);

      canvas.drawArc(
        frownRect,
        1.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood || oldDelegate.faceType != faceType;
  }
}
