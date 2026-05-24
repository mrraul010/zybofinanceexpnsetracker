import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerLoader extends StatelessWidget {
  const HomeShimmerLoader({super.key});

  static const Color _base = Color(0xFF2A2A2A);
  static const Color _highlight = Color(0xFF3D3D3D);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      period: const Duration(milliseconds: 1400),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _ShimmerHeader(),
            const SizedBox(height: 24),
            _ShimmerSummaryCards(),
            const SizedBox(height: 20),
            _ShimmerMonthlyLimit(),
            const SizedBox(height: 28),
            _ShimmerRecentTransactions(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

class _ShimmerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(width: 180, height: 16, radius: 8),
            const SizedBox(height: 6),
            _ShimmerBox(width: 120, height: 14, radius: 8),
          ],
        ),

        _ShimmerBox(width: 40, height: 40, radius: 12),
      ],
    );
  }
}

class _ShimmerSummaryCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ShimmerSummaryCard()),
        const SizedBox(width: 14),
        Expanded(child: _ShimmerSummaryCard()),
      ],
    );
  }
}

class _ShimmerSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ShimmerBox(width: 32, height: 32, radius: 10),
              const SizedBox(width: 10),
              _ShimmerBox(width: 70, height: 13, radius: 6),
            ],
          ),
          const SizedBox(height: 14),
          _ShimmerBox(width: 90, height: 22, radius: 8),
          const SizedBox(height: 6),
          _ShimmerBox(width: 55, height: 11, radius: 5),
        ],
      ),
    );
  }
}

class _ShimmerMonthlyLimit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(width: 130, height: 14, radius: 7),
              _ShimmerBox(width: 60, height: 14, radius: 7),
            ],
          ),
          const SizedBox(height: 14),

          _ShimmerBox(width: double.infinity, height: 8, radius: 4),
          const SizedBox(height: 10),

          _ShimmerBox(width: 160, height: 11, radius: 5),
        ],
      ),
    );
  }
}

class _ShimmerRecentTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ShimmerBox(width: 170, height: 18, radius: 8),
            _ShimmerBox(width: 48, height: 13, radius: 6),
          ],
        ),
        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, __) => _ShimmerTransactionTile(),
        ),
      ],
    );
  }
}

class _ShimmerTransactionTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _ShimmerBox(width: 44, height: 44, radius: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 120, height: 14, radius: 6),
                const SizedBox(height: 8),
                _ShimmerBox(width: 80, height: 11, radius: 5),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ShimmerBox(width: 70, height: 14, radius: 6),
              const SizedBox(height: 8),
              _ShimmerBox(width: 40, height: 11, radius: 5),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
