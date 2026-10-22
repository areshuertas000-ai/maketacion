import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum AuthDecoration { login, register, recovery, verification, reset, home }

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.child,
    required this.decoration,
    super.key,
    this.onBack,
    this.footer,
    this.centerContent = false,
  });
  final Widget child;
  final AuthDecoration decoration;
  final VoidCallback? onBack;
  final Widget? footer;
  final bool centerContent;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (layoutContext, outer) {
          final desktop = outer.maxWidth > 500;
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 430,
                maxHeight: desktop ? 844 : double.infinity,
              ),
              margin: EdgeInsets.all(desktop ? 24 : 0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(desktop ? 28 : 0),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF6F3FF), Colors.white],
                ),
                boxShadow: desktop
                    ? [
                        const BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 40,
                          offset: Offset(0, 12),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _BackgroundPainter(decoration),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      // Cuando hay barra de estado nativa se conserva la del sistema.
                      if (MediaQuery.viewPaddingOf(context).top == 0)
                        const _StatusBar(),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, box) => SingleChildScrollView(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: box.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    24,
                                    8,
                                    24,
                                    20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (onBack != null) ...[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton.filledTonal(
                                            tooltip: 'Volver',
                                            onPressed: onBack,
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              minimumSize: const Size(44, 44),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.chevron_left,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                      ] else if (!centerContent)
                                        const SizedBox(height: 28),
                                      if (centerContent) const Spacer(),
                                      child,
                                      const Spacer(),
                                      if (centerContent) const Spacer(),
                                      if (footer != null) ...[
                                        const SizedBox(height: 24),
                                        footer!,
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (MediaQuery.viewPaddingOf(context).bottom == 0)
                        const ExcludeSemantics(child: _HomeIndicator()),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        children: [
          const Text(
            '9:41',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          const Icon(Icons.signal_cellular_alt, size: 15),
          const SizedBox(width: 5),
          const Icon(Icons.wifi, size: 15),
          const SizedBox(width: 5),
          Transform.rotate(
            angle: math.pi / 2,
            child: const Icon(Icons.battery_full, size: 18),
          ),
        ],
      ),
    ),
  );
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9, top: 6),
    child: Container(
      width: 110,
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.ink.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter(this.kind);
  final AuthDecoration kind;
  @override
  void paint(Canvas canvas, Size size) {
    final wide = size.width;
    final warm =
        kind == AuthDecoration.register || kind == AuthDecoration.verification;
    final blue = kind == AuthDecoration.recovery;
    final colors = warm
        ? [const Color(0xFFFF637A), const Color(0xFFFF8B20)]
        : blue
        ? [const Color(0xFF26BCD9), const Color(0xFF6282FA)]
        : [const Color(0xFF9444EA), const Color(0xFFF34CA2)];
    final bubble = Rect.fromCircle(center: Offset(wide - 16, 6), radius: 152);
    canvas.drawCircle(
      bubble.center,
      152,
      Paint()..shader = LinearGradient(colors: colors).createShader(bubble),
    );
    canvas.drawCircle(
      Offset(
        kind == AuthDecoration.login || kind == AuthDecoration.home
            ? 58
            : wide - 24,
        kind == AuthDecoration.login ? 84 : 210,
      ),
      12,
      Paint()..color = const Color(0xFFFFCC08),
    );
    if (warm) {
      canvas.drawCircle(
        Offset(wide - 64, 182),
        22,
        Paint()
          ..color = const Color(0xFFA264FF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6,
      );
    }
    if (kind == AuthDecoration.login) {
      canvas.drawCircle(
        const Offset(-48, 220),
        112,
        Paint()..color = const Color(0xFFB6DBFB).withValues(alpha: 0.65),
      );
      canvas.drawCircle(
        Offset(4, size.height - 190),
        16,
        Paint()
          ..color = const Color(0xFF31C6D8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }
    if (kind == AuthDecoration.register || kind == AuthDecoration.home) {
      canvas.drawCircle(
        Offset(6, size.height * 0.48),
        18,
        Paint()
          ..color = const Color(0xFFF270C3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }
    final leftBottom =
        kind == AuthDecoration.login ||
        kind == AuthDecoration.home ||
        kind == AuthDecoration.reset;
    final bottomColor = kind == AuthDecoration.login
        ? const Color(0xFFFADDEF)
        : kind == AuthDecoration.recovery
        ? const Color(0xFFFFE2AF)
        : const Color(0xFFBCE6F3);
    canvas.drawCircle(
      Offset(leftBottom ? -18 : wide - 18, size.height - 12),
      kind == AuthDecoration.home ? 124 : 86,
      Paint()..color = bottomColor,
    );
    if (leftBottom ||
        kind == AuthDecoration.register ||
        kind == AuthDecoration.verification ||
        blue) {
      final rect = Rect.fromLTWH(
        0,
        0,
        leftBottom ? 58 : 45,
        leftBottom ? 64 : 48,
      );
      canvas.save();
      canvas.translate(
        leftBottom ? wide - 36 : 7,
        size.height - (leftBottom ? 68 : 30),
      );
      canvas.rotate(leftBottom ? -0.3 : 0.3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(15)),
        Paint()
          ..shader = LinearGradient(
            colors: leftBottom
                ? [const Color(0xFFFFCC28), const Color(0xFFFF842B)]
                : [const Color(0xFFAB50F3), const Color(0xFFED60AA)],
          ).createShader(rect),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) =>
      oldDelegate.kind != kind;
}
