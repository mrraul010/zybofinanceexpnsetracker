import 'package:flutter/material.dart';







enum SnackbarType { success, error, warning, info, neutral }

class SnackbarConfig {
  final Color background;
  final Color borderColor;
  final Color textColor;
  final Color subtitleColor;
  final Color progressColor;
  final Color actionColor;
  final IconData icon;

  const SnackbarConfig({
    required this.background,
    required this.borderColor,
    required this.textColor,
    required this.subtitleColor,
    required this.progressColor,
    required this.actionColor,
    required this.icon,
  });
}

final Map<SnackbarType, SnackbarConfig> snackbarConfigs = {
  SnackbarType.success: SnackbarConfig(
    background: const Color(0xFFEAF3DE),
    borderColor: const Color(0xFF97C459),
    textColor: const Color(0xFF27500A),
    subtitleColor: const Color(0xFF3B6D11),
    progressColor: const Color(0xFF639922),
    actionColor: const Color(0xFF3B6D11),
    icon: Icons.check_circle_outline_rounded,
  ),
  SnackbarType.error: SnackbarConfig(
    background: const Color(0xFFFCEBEB),
    borderColor: const Color(0xFFF09595),
    textColor: const Color(0xFF501313),
    subtitleColor: const Color(0xFFA32D2D),
    progressColor: const Color(0xFFE24B4A),
    actionColor: const Color(0xFFA32D2D),
    icon: Icons.error_outline_rounded,
  ),
  SnackbarType.warning: SnackbarConfig(
    background: const Color(0xFFFAEEDA),
    borderColor: const Color(0xFFEF9F27),
    textColor: const Color(0xFF412402),
    subtitleColor: const Color(0xFF854F0B),
    progressColor: const Color(0xFFBA7517),
    actionColor: const Color(0xFF854F0B),
    icon: Icons.warning_amber_rounded,
  ),
  SnackbarType.info: SnackbarConfig(
    background: const Color(0xFFE6F1FB),
    borderColor: const Color(0xFF85B7EB),
    textColor: const Color(0xFF042C53),
    subtitleColor: const Color(0xFF185FA5),
    progressColor: const Color(0xFF378ADD),
    actionColor: const Color(0xFF185FA5),
    icon: Icons.info_outline_rounded,
  ),
  SnackbarType.neutral: SnackbarConfig(
    background: const Color(0xFF2C2C2A),
    borderColor: const Color(0xFF5F5E5A),
    textColor: const Color(0xFFF1EFE8),
    subtitleColor: const Color(0xFFD3D1C7),
    progressColor: const Color(0xFFB4B2A9),
    actionColor: const Color(0xFFD3D1C7),
    icon: Icons.notifications_none_rounded,
  ),
};



class AwesomeSnackbar extends StatefulWidget {
  final SnackbarType type;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final Duration duration;

  const AwesomeSnackbar({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<AwesomeSnackbar> createState() => _AwesomeSnackbarState();
}

class _AwesomeSnackbarState extends State<AwesomeSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _progressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = snackbarConfigs[widget.type]!;

    return Container(
      decoration: BoxDecoration(
        color: config.background,
        border: Border.all(color: config.borderColor, width: 0.8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: config.borderColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
            child: Row(
              children: [
                Icon(config.icon, color: config.subtitleColor, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: config.textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.message,
                        style: TextStyle(
                          color: config.subtitleColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.actionLabel != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      widget.onAction?.call();
                      widget.onDismiss?.call();
                    },
                    child: Text(
                      widget.actionLabel!,
                      style: TextStyle(
                        color: config.actionColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: config.actionColor,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onDismiss,
                  child: Icon(Icons.close_rounded,
                      color: config.subtitleColor, size: 18),
                ),
              ],
            ),
          ),
      
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, _) {
              return Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: config.progressColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(3),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



void showAwesomeSnackbar({
  required BuildContext context,
  required SnackbarType type,
  required String title,
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (ctx) => _SnackbarOverlay(
      type: type,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      onDismiss: () => entry.remove(),
    ),
  );

  overlay.insert(entry);

  Future.delayed(duration + const Duration(milliseconds: 400), () {
    if (entry.mounted) entry.remove();
  });
}

class _SnackbarOverlay extends StatefulWidget {
  final SnackbarType type;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;
  final Duration duration;

  const _SnackbarOverlay({
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_SnackbarOverlay> createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<_SnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
    await _animController.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: AwesomeSnackbar(
              type: widget.type,
              title: widget.title,
              message: widget.message,
              actionLabel: widget.actionLabel,
              onAction: widget.onAction,
              onDismiss: _dismiss,
              duration: widget.duration,
            ),
          ),
        ),
      ),
    );
  }
}

