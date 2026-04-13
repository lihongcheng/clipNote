import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A polished animated splash screen shown during app initialization.
///
/// Usage in main.dart:
///   home: const SplashScreen(),
///
/// SplashScreen internally calls [onInit] to run async startup work,
/// then navigates to [MainShell] automatically.
class SplashScreen extends StatefulWidget {
  /// Called once the animation is ready. Run your async init here.
  final Future<void> Function()? onInit;

  const SplashScreen({super.key, this.onInit});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────────────────
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _exitCtrl;

  // ── Logo animations ───────────────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoY;

  // ── Text animations ───────────────────────────────────────────────────────
  late final Animation<double> _textOpacity;
  late final Animation<double> _textY;
  late final Animation<double> _taglineOpacity;

  // ── Pulse / shimmer ───────────────────────────────────────────────────────
  late final Animation<double> _pulse;

  // ── Exit ─────────────────────────────────────────────────────────────────
  late final Animation<double> _exitOpacity;

  bool _initDone = false;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _pulseCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _exitCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    final logoEase = CurvedAnimation(
        parent: _logoCtrl,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeIn);
    final logoFade =
        CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.4));
    final textEase = CurvedAnimation(
        parent: _textCtrl, curve: Curves.easeOutCubic);

    _logoScale = Tween(begin: 0.55, end: 1.0).animate(logoEase);
    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(logoFade);
    _logoY = Tween(begin: 28.0, end: 0.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutCubic));

    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(textEase);
    _textY = Tween(begin: 16.0, end: 0.0).animate(textEase);
    _taglineOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _textCtrl,
            curve: const Interval(0.35, 1.0, curve: Curves.easeOut)));

    _pulse = Tween(begin: 0.92, end: 1.08).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _exitOpacity = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _exitCtrl, curve: Curves.easeInCubic));

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Small delay so the background color settles
    await Future.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;

    await _logoCtrl.forward();
    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;

    _textCtrl.forward();

    // Run init work in parallel with the animation
    if (widget.onInit != null) {
      await widget.onInit!();
    }

    // Ensure minimum display time (UX)
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() => _initDone = true);
  }

  Future<void> _navigateAway() async {
    _pulseCtrl.stop();
    await _exitCtrl.forward();
    if (!mounted) return;
    // Pop the splash and reveal whatever is underneath.
    // If used as home, push a replacement instead:
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _pulseCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
        isDark ? const Color(0xFF100E1A) : const Color(0xFFF8F7FF);
    final glowColor = cs.primary.withValues(alpha: 0.18);

    return AnimatedBuilder(
      animation: Listenable.merge(
          [_logoCtrl, _textCtrl, _pulseCtrl, _exitCtrl]),
      builder: (context, _) {
        return FadeTransition(
          opacity: _exitOpacity,
          child: Scaffold(
            backgroundColor: bgColor,
            body: Stack(
              children: [
                // ── Ambient glow blob ──────────────────────────────────
                Positioned(
                  top: -80,
                  left: -60,
                  child: _GlowBlob(
                    size: 420,
                    color: cs.tertiary.withValues(alpha: 0.10),
                    pulse: _pulse.value,
                  ),
                ),
                Positioned(
                  bottom: -60,
                  right: -80,
                  child: _GlowBlob(
                    size: 340,
                    color: cs.primary.withValues(alpha: 0.09),
                    pulse: 2.0 - _pulse.value, // inverse
                  ),
                ),

                // ── Center content ─────────────────────────────────────
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Transform.translate(
                        offset: Offset(0, _logoY.value),
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: _LogoCard(
                              primaryColor: cs.primary,
                              glowColor: glowColor,
                              isDark: isDark,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // App name
                      Transform.translate(
                        offset: Offset(0, _textY.value),
                        child: Opacity(
                          opacity: _textOpacity.value,
                          child: Column(
                            children: [
                              Text(
                                'ClipNote',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -1.2,
                                      color: cs.onSurface,
                                      fontSize: 40,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Opacity(
                                opacity: _taglineOpacity.value,
                                child: Text(
                                  'Clipboard · Notes · Tasks',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.4,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── "Continue" button appears when ready ───────────────
                if (_initDone)
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (ctx, v, _) => Opacity(
                        opacity: v,
                        child: Transform.translate(
                          offset: Offset(0, 12 * (1 - v)),
                          child: Center(
                            child: FilledButton(
                              onPressed: _navigateAway,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(200, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // ── Loading dots while initializing ───────────────────
                if (!_initDone)
                  Positioned(
                    bottom: 72,
                    left: 0,
                    right: 0,
                    child: _LoadingDots(color: cs.primary),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Logo card widget ─────────────────────────────────────────────────────────
class _LogoCard extends StatelessWidget {
  final Color primaryColor;
  final Color glowColor;
  final bool isDark;

  const _LogoCard(
      {required this.primaryColor,
      required this.glowColor,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surfaceColor =
        isDark ? const Color(0xFF1E1B2E) : const Color(0xFFEDE9FF);
    final lineColor =
        isDark ? const Color(0xFF4A3F70) : const Color(0xFFBDB0E0);

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.20),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.30 : 0.18),
            blurRadius: 40,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ClipboardPainter(
          primaryColor: primaryColor,
          lineColor: lineColor,
          isDark: isDark,
        ),
      ),
    );
  }
}

// ── Clipboard icon painter ────────────────────────────────────────────────────
class _ClipboardPainter extends CustomPainter {
  final Color primaryColor;
  final Color lineColor;
  final bool isDark;

  const _ClipboardPainter(
      {required this.primaryColor,
      required this.lineColor,
      required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..color = isDark
          ? const Color(0xFF2A2545)
          : const Color(0xFFDDD6FF);
    final borderPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final accentPaint = Paint()..color = primaryColor;
    final dimPaint = Paint()..color = lineColor;
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF100E1A) : const Color(0xFFF8F7FF);

    final cw = w * 0.56;
    final ch = h * 0.62;
    final cl = (w - cw) / 2;
    final ct = (h - ch) / 2 + h * 0.04;

    // Clipboard body
    final bodyRect = RRect.fromLTRBR(cl, ct, cl+cw, ct+ch, Radius.circular(cw * 0.13));
    canvas.drawRRect(bodyRect, bodyPaint);
    canvas.drawRRect(bodyRect, borderPaint);

    // Clip bar
    final bw = cw * 0.46;
    final bh = h * 0.072;
    final bl = (w - bw) / 2;
    final bt = ct - bh / 2;
    canvas.drawRRect(
        RRect.fromLTRBR(bl, bt, bl+bw, bt+bh, Radius.circular(bh / 2)),
        accentPaint);

    // Clip hole
    final hw = w * 0.088;
    canvas.drawCircle(Offset(w/2, bt + bh/2), hw/2, bgPaint);

    // Lines
    final lx = cl + cw * 0.14;
    final lw2 = cw * 0.72;
    final lh = math.max(h * 0.038, 3.0);
    final gap = h * 0.082;
    final ly0 = ct + ch * 0.20;

    final lineConfigs = [
      (1.00, accentPaint),
      (0.72, dimPaint),
      (0.86, dimPaint),
      (0.60, Paint()..color = primaryColor.withValues(alpha: 0.65)),
      (0.50, dimPaint),
    ];

    for (var i = 0; i < lineConfigs.length; i++) {
      final (wf, paint) = lineConfigs[i];
      final ly = ly0 + i * gap;
      canvas.drawRRect(
          RRect.fromLTRBR(lx, ly, lx + lw2*wf, ly+lh, Radius.circular(lh/2)),
          paint);
    }

    // Check badge
    final br = w * 0.165;
    final bx = cl + cw - br * 0.30;
    final byy = ct + ch - br * 0.30;
    // shadow
    canvas.drawCircle(Offset(bx, byy), br + 3,
        Paint()..color = primaryColor.withValues(alpha: 0.25));
    canvas.drawCircle(Offset(bx, byy), br, accentPaint);
    // checkmark
    final ck = br * 0.50;
    final checkPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = math.max(w * 0.030, 2.5)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(bx - ck*0.52, byy + ck*0.05)
      ..lineTo(bx - ck*0.08, byy + ck*0.52)
      ..lineTo(bx + ck*0.62, byy - ck*0.52);
    canvas.drawPath(path, checkPaint);
  }

  @override
  bool shouldRepaint(_ClipboardPainter old) =>
      old.primaryColor != primaryColor || old.isDark != isDark;
}

// ── Ambient glow blob ─────────────────────────────────────────────────────────
class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double pulse;

  const _GlowBlob(
      {required this.size, required this.color, required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: pulse,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

// ── Animated loading dots ─────────────────────────────────────────────────────
class _LoadingDots extends StatefulWidget {
  final Color color;
  const _LoadingDots({required this.color});

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
            final bounce = math.sin(phase * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.translate(
                offset: Offset(0, -6 * bounce),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color
                        .withValues(alpha: 0.4 + 0.6 * bounce),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}