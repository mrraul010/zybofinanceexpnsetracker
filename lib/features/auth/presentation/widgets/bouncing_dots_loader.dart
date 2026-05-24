import 'package:flutter/material.dart';

class BouncingDotsLoader extends StatefulWidget {
  final Color color;
  final double dotSize;
  final double bounceHeight;

  const BouncingDotsLoader({
    super.key,
    this.color = Colors.white,
    this.dotSize = 8,
    this.bounceHeight = 8,
  });

  @override
  State<BouncingDotsLoader> createState() => _BouncingDotsLoaderState();
}

class _BouncingDotsLoaderState extends State<BouncingDotsLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _anims = _controllers.map((ctrl) {
      return Tween<double>(begin: 0, end: -widget.bounceHeight).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
      );
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final ctrl in _controllers) ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(0, _anims[i].value),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}