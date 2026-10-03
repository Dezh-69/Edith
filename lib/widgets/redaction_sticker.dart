import 'package:flutter/material.dart';

class RedactionSticker extends StatefulWidget {
  final VoidCallback onClose;
  const RedactionSticker({super.key, required this.onClose});

  @override
  State<RedactionSticker> createState() => _RedactionStickerState();
}

class _RedactionStickerState extends State<RedactionSticker> {
  double _top = 150;
  double _left = 150;
  double _width = 200;
  double _height = 50;

  bool _isEditing = true;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _top,
      left: _left,
      width: _width,
      height: _height,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
        onPanUpdate: _isEditing ? (details) {
          setState(() {
            _top += details.delta.dy;
            _left += details.delta.dx;
          });
        } : null,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF002210), // Dark academic redaction tape
            borderRadius: BorderRadius.circular(4),
            border: _isEditing ? Border.all(color: const Color(0xFF7DA288), width: 2) : null,
            boxShadow: [
              if (!_isEditing)
                const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: _isEditing ? Stack(
            children: [
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  icon: const Icon(Icons.cancel, color: Color(0xFFF9FAF7), size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: widget.onClose,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _width = (_width + details.delta.dx).clamp(20.0, 1000.0);
                      _height = (_height + details.delta.dy).clamp(20.0, 1000.0);
                    });
                  },
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.resizeDownRight,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.open_in_full, size: 16, color: Color(0xFF7DA288)),
                    ),
                  ),
                ),
              ),
            ],
          ) : null,
        ),
      ),
    );
  }
}
