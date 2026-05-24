import 'dart:math' as math;
import 'package:flutter/material.dart';

class SyncLoadingAnimationButton extends StatefulWidget {
  const SyncLoadingAnimationButton({super.key});

  @override
  State<SyncLoadingAnimationButton> createState() =>
      _SyncLoadingAnimationButtonState();
}

class _SyncLoadingAnimationButtonState extends State<SyncLoadingAnimationButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _dotOpacity(int index) {
    final t = (_ctrl.value + index / 3) % 1.0;
    return (t < 0.5 ? t * 2 : 1.0 - (t - 0.5) * 2).clamp(0.2, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final glow = (math.sin(_ctrl.value * 2 * math.pi) * 0.5 + 0.5);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF4B3FE4),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4B3FE4).withOpacity(glow * 0.45),
                blurRadius: 20 + glow * 12,
                spreadRadius: glow * 3,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: _ctrl.value * 2 * math.pi,
                      child: CustomPaint(
                        size: const Size(44, 44),
                        painter: _ArrowRingPainter(),
                      ),
                    ),

                    Transform.rotate(
                      angle: -_ctrl.value * math.pi,
                      child: Icon(
                        Icons.cloud_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 17,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Syncing to Cloud',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Uploading your data',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 2),

                        ...List.generate(3, (i) {
                          return Opacity(
                            opacity: _dotOpacity(i),
                            child: Text(
                              ' •',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArrowRingPainter extends CustomPainter {
  _ArrowRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3.5;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final arcPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const double sweep = 2.4;
    const double arc1Start = -math.pi / 2 - sweep / 2;
    canvas.drawArc(rect, arc1Start, sweep, false, arcPaint);

    const double arc2Start = math.pi / 2 - sweep / 2;
    canvas.drawArc(rect, arc2Start, sweep, false, arcPaint);

    _drawArrowhead(canvas, center, radius, arc1Start + sweep, 1);
    _drawArrowhead(canvas, center, radius, arc2Start + sweep, 1);
  }

  void _drawArrowhead(
    Canvas canvas,
    Offset center,
    double radius,
    double endAngle,
    int direction,
  ) {
    final tip = Offset(
      center.dx + radius * math.cos(endAngle),
      center.dy + radius * math.sin(endAngle),
    );

    final tangent = endAngle + direction * math.pi / 2;
    const double size = 5.5;
    const double spread = 0.45;

    final left = Offset(
      tip.dx + size * math.cos(tangent + math.pi - spread),
      tip.dy + size * math.sin(tangent + math.pi - spread),
    );
    final right = Offset(
      tip.dx + size * math.cos(tangent + math.pi + spread),
      tip.dy + size * math.sin(tangent + math.pi + spread),
    );

    canvas.drawPath(
      Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(left.dx, left.dy)
        ..lineTo(right.dx, right.dy)
        ..close(),
      Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_ArrowRingPainter oldDelegate) => false;
}
