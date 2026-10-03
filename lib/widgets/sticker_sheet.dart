import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class Stroke {
  final List<PointVector> points;
  final Color color;
  final double size;

  Stroke({required this.points, required this.color, required this.size});
}

class StickerSheet extends StatefulWidget {
  final VoidCallback? onClose;
  final bool isFullscreen;
  const StickerSheet({super.key, this.onClose, this.isFullscreen = false});

  @override
  State<StickerSheet> createState() => _StickerSheetState();
}

class _StickerSheetState extends State<StickerSheet> {
  final List<Stroke> _strokes = [];
  Stroke? _currentStroke;
  
  double _top = 100;
  double _left = 100;
  double _width = 300;
  double _height = 300;

  @override
  Widget build(BuildContext context) {
    if (widget.isFullscreen) {
      return Positioned.fill(
        child: _buildCanvas(),
      );
    }

    return Positioned(
      top: _top,
      left: _left,
      width: _width,
      height: _height,
      child: Material(
        elevation: 8,
        color: const Color(0xFFF9FAF7).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Header for dragging
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _top += details.delta.dy;
                  _left += details.delta.dx;
                });
              },
              child: Container(
                height: 32,
                color: const Color(0xFFEDEEEB),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.drag_indicator, size: 16, color: Color(0xFF424843)),
                    ),
                    if (widget.onClose != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Color(0xFF163824)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: widget.onClose!,
                      )
                  ],
                ),
              ),
            ),
            // Canvas for drawing
            Expanded(
              child: Stack(
                children: [
                  _buildCanvas(),
                  // Resize Handle
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _width = (_width + details.delta.dx).clamp(100.0, 800.0);
                          _height = (_height + details.delta.dy).clamp(100.0, 800.0);
                        });
                      },
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.resizeDownRight,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.open_in_full, size: 16, color: Color(0xFF727972)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvas() {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _currentStroke = Stroke(
            points: [PointVector(details.localPosition.dx, details.localPosition.dy)],
            color: widget.isFullscreen ? const Color(0xFFFB7185) : const Color(0xFF163824), // Red for locked mode, dark green for sticker
            size: 5.0,
          );
          _strokes.add(_currentStroke!);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _currentStroke?.points.add(PointVector(details.localPosition.dx, details.localPosition.dy));
        });
      },
      onPanEnd: (details) {
        _currentStroke = null;
      },
      child: Container(
        color: Colors.transparent,
        child: CustomPaint(
          painter: _FreehandPainter(strokes: _strokes),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _FreehandPainter extends CustomPainter {
  final List<Stroke> strokes;

  _FreehandPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final path = Path();
      final outlinePoints = getStroke(
        stroke.points,
        options: StrokeOptions(
          size: stroke.size,
          thinning: 0.5,
          smoothing: 0.5,
          streamline: 0.5,
        ),
      );

      if (outlinePoints.isEmpty) continue;
      
      path.moveTo(outlinePoints.first.dx, outlinePoints.first.dy);
      for (int i = 1; i < outlinePoints.length - 1; ++i) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        path.quadraticBezierTo(p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      }

      final paint = Paint()
        ..color = stroke.color
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
