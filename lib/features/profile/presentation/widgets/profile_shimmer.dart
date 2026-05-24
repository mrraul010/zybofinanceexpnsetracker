import 'package:flutter/material.dart';

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 10,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value, 0),
            colors: const [
              Color(0xFF1E1E1E),
              Color(0xFF2C2C2C),
              Color(0xFF363636),
              Color(0xFF2C2C2C),
              Color(0xFF1E1E1E),
            ],
            stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
        ),
      ),
    );
  }
}

class ProfileShimmer extends StatefulWidget {
  const ProfileShimmer({super.key});

  @override
  State<ProfileShimmer> createState() => _ProfileShimmerState();
}

class _ProfileShimmerState extends State<ProfileShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Widget _label() => const _ShimmerBox(width: 80, height: 11, borderRadius: 4);

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
    ),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeCtrl,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            const _ShimmerBox(width: 200, height: 26, borderRadius: 6),
            const SizedBox(height: 28),

            _label(),
            const SizedBox(height: 10),
            _card(
              child: Row(
                children: [
                  const Expanded(
                    child: _ShimmerBox(
                      width: double.infinity,
                      height: 22,
                      borderRadius: 5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: _ShimmerBox(
                        width: 18,
                        height: 18,
                        borderRadius: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: _ShimmerBox(
                          width: double.infinity,
                          height: 48,
                          borderRadius: 10,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 60,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2660),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: _ShimmerBox(
                            width: 28,
                            height: 14,
                            borderRadius: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _ShimmerBox(width: 160, height: 13, borderRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _label(),
            const SizedBox(height: 10),
            _card(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: _ShimmerBox(
                          width: double.infinity,
                          height: 48,
                          borderRadius: 10,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2660),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...List.generate(4, (i) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: _ShimmerBox(
                                  width: (120 + i * 20).toDouble(),
                                  height: 15,
                                  borderRadius: 4,
                                ),
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A1515),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: _ShimmerBox(
                                    width: 18,
                                    height: 18,
                                    borderRadius: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (i < 3)
                          const Divider(color: Color(0xFF242424), height: 1),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _label(),
            const SizedBox(height: 10),
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2660),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ShimmerBox(width: 120, height: 16, borderRadius: 4),
                        SizedBox(height: 8),
                        _ShimmerBox(width: 180, height: 12, borderRadius: 4),
                      ],
                    ),
                  ),
                  _ShimmerBox(width: 28, height: 28, borderRadius: 6),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
              ),
              child: const Center(
                child: _ShimmerBox(width: 80, height: 16, borderRadius: 4),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
