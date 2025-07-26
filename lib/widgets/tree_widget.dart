import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';

class TreeWidget extends StatelessWidget {
  const TreeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        return SizedBox(
          height: 300,
          width: 300,
          child: Stack(
            children: [
              // Enhanced isometric grid background
              Positioned.fill(
                child: _buildIsometricGrid(),
              ),
              
              // Tree in center - larger and more prominent
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildTree(timerProvider.treeGrowthStage),
                ),
              ),
              
              // Watering can - repositioned
              Positioned(
                top: 30,
                left: 40,
                child: _buildWateringCan(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIsometricGrid() {
    return CustomPaint(
      size: const Size(300, 300),
      painter: IsometricGridPainter(),
    );
  }

  Widget _buildTree(int growthStage) {
    return SizedBox(
      width: 80,
      height: 120,
      child: CustomPaint(
        painter: TreePainter(growthStage),
      ),
    );
  }

  Widget _buildWateringCan() {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: WateringCanPainter(),
      ),
    );
  }
}

class IsometricGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = const Color(0xFF8B4513).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final cellWidth = 40.0;
    final cellHeight = 20.0;

    // Draw 3D isometric grid (4x4 for better coverage)
    for (int row = -2; row <= 2; row++) {
      for (int col = -2; col <= 2; col++) {
        final x = center.dx + (col - row) * cellWidth * 0.5;
        final y = center.dy + (col + row) * cellHeight * 0.5;
        
        // Create diamond/rhombus shape for isometric effect
        final path = Path();
        path.moveTo(x, y - cellHeight / 2); // Top
        path.lineTo(x + cellWidth / 2, y); // Right
        path.lineTo(x, y + cellHeight / 2); // Bottom
        path.lineTo(x - cellWidth / 2, y); // Left
        path.close();
        
        // Fill first, then stroke
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TreePainter extends CustomPainter {
  final int growthStage;

  TreePainter(this.growthStage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    
    // Draw 3D pot/soil base
    final soilPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;
    
    final soilShadowPaint = Paint()
      ..color = const Color(0xFF5D2F0A)
      ..style = PaintingStyle.fill;
    
    // Draw pot shadow (bottom face)
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx + 2, center.dy - 8),
        width: 28,
        height: 12,
      ),
      soilShadowPaint,
    );
    
    // Draw main pot
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 10),
        width: 26,
        height: 12,
      ),
      soilPaint,
    );

    // Draw tree based on growth stage
    final treePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    switch (growthStage) {
      case 1: // Sapling
        _drawSapling(canvas, center, treePaint);
        break;
      case 2: // Small tree
        _drawSmallTree(canvas, center, treePaint);
        break;
      case 3: // Medium tree
        _drawMediumTree(canvas, center, treePaint);
        break;
      case 4: // Full tree
        _drawFullTree(canvas, center, treePaint);
        break;
    }
  }

  void _drawSapling(Canvas canvas, Offset center, Paint paint) {
    // Draw tiny stem
    final stemPaint = Paint()
      ..color = const Color(0xFF4A3728)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 15),
        width: 3,
        height: 15,
      ),
      stemPaint,
    );

    // Draw small leaves
    canvas.drawCircle(
      Offset(center.dx - 6, center.dy - 25),
      5,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + 6, center.dy - 25),
      5,
      paint,
    );
  }

  void _drawSmallTree(Canvas canvas, Offset center, Paint paint) {
    // Draw trunk with gradient effect
    final trunkPaint = Paint()
      ..color = const Color(0xFF4A3728)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 25),
        width: 6,
        height: 30,
      ),
      trunkPaint,
    );

    // Draw leaves with depth
    final darkGreen = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(center.dx + 2, center.dy - 42),
      15,
      darkGreen,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy - 45),
      14,
      paint,
    );
  }

  void _drawMediumTree(Canvas canvas, Offset center, Paint paint) {
    // Draw trunk with texture
    final trunkPaint = Paint()
      ..color = const Color(0xFF4A3728)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 35),
        width: 8,
        height: 40,
      ),
      trunkPaint,
    );

    // Draw layered foliage for depth
    final darkGreen = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    
    // Shadow layer
    canvas.drawCircle(
      Offset(center.dx + 3, center.dy - 57),
      18,
      darkGreen,
    );
    canvas.drawCircle(
      Offset(center.dx - 5, center.dy - 52),
      10,
      darkGreen,
    );
    canvas.drawCircle(
      Offset(center.dx + 10, center.dy - 52),
      10,
      darkGreen,
    );
    
    // Main foliage
    canvas.drawCircle(
      Offset(center.dx, center.dy - 60),
      17,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx - 8, center.dy - 55),
      9,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + 8, center.dy - 55),
      9,
      paint,
    );
  }

  void _drawFullTree(Canvas canvas, Offset center, Paint paint) {
    // Draw thick trunk
    final trunkPaint = Paint()
      ..color = const Color(0xFF4A3728)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 45),
        width: 12,
        height: 50,
      ),
      trunkPaint,
    );

    // Draw full, lush foliage with multiple layers
    final darkGreen = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    
    // Shadow layer for depth
    canvas.drawCircle(
      Offset(center.dx + 4, center.dy - 77),
      25,
      darkGreen,
    );
    canvas.drawCircle(
      Offset(center.dx - 8, center.dy - 72),
      15,
      darkGreen,
    );
    canvas.drawCircle(
      Offset(center.dx + 15, center.dy - 72),
      15,
      darkGreen,
    );
    canvas.drawCircle(
      Offset(center.dx + 2, center.dy - 62),
      12,
      darkGreen,
    );
    
    // Main bright foliage
    canvas.drawCircle(
      Offset(center.dx, center.dy - 80),
      24,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx - 12, center.dy - 75),
      14,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + 12, center.dy - 75),
      14,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy - 65),
      11,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WateringCanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw watering can outline
    final center = Offset(size.width / 2, size.height / 2);
    
    // Can body
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 5),
        width: 20,
        height: 15,
      ),
      paint,
    );
    
    // Spout
    canvas.drawLine(
      Offset(center.dx + 10, center.dy),
      Offset(center.dx + 15, center.dy - 5),
      paint,
    );
    
    // Handle
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx - 5, center.dy),
        width: 10,
        height: 10,
      ),
      0,
      3.14,
      false,
      paint,
    );

    // Water drops
    final dropPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(center.dx + 15 + i * 2, center.dy - 5 - i * 3),
        Offset(center.dx + 15 + i * 2, center.dy - 8 - i * 3),
        dropPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 