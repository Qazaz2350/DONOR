import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Floating Particle Animation Widget
/// Adds beautiful floating particles in the background
class FloatingParticles extends StatefulWidget {
  final int numberOfParticles;
  final Color color;
  final double maxSize;
  final double minSize;

  const FloatingParticles({
    super.key,
    this.numberOfParticles = 20,
    this.color = Colors.white,
    this.maxSize = 8.0,
    this.minSize = 2.0,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate particles
    for (int i = 0; i < widget.numberOfParticles; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size:
              widget.minSize +
              _random.nextDouble() * (widget.maxSize - widget.minSize),
          speedX: (_random.nextDouble() - 0.5) * 0.002,
          speedY: (_random.nextDouble() - 0.5) * 0.002,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Update particle positions
        for (var particle in _particles) {
          particle.x += particle.speedX;
          particle.y += particle.speedY;

          // Wrap around edges
          if (particle.x > 1) particle.x = 0;
          if (particle.x < 0) particle.x = 1;
          if (particle.y > 1) particle.y = 0;
          if (particle.y < 0) particle.y = 1;
        }

        return CustomPaint(
          painter: ParticlePainter(_particles, widget.color),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;

  ParticlePainter(this.particles, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Shimmer Loading Widget
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color highlightColor;
  final Color baseColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.highlightColor = Colors.white,
    this.baseColor = const Color(0xFFE0E0E0),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Ripple Animation Widget
class RippleAnimation extends StatefulWidget {
  final Widget child;
  final Color color;
  final Duration duration;

  const RippleAnimation({
    super.key,
    required this.child,
    this.color = Colors.blue,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ripple
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + (_controller.value * 0.5),
              child: Opacity(
                opacity: 1 - _controller.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.color, width: 2),
                  ),
                ),
              ),
            );
          },
        ),
        // Inner ripple
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delayedValue = (_controller.value - 0.3).clamp(0.0, 1.0);
            return Transform.scale(
              scale: 1 + (delayedValue * 0.5),
              child: Opacity(
                opacity: 1 - delayedValue,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withOpacity(0.6),
                      width: 2,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

/// Bouncing Widget Animation
class BouncingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scaleFactor;

  const BouncingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.scaleFactor = 1.1,
  });

  @override
  State<BouncingWidget> createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}

/// Gradient Text Widget
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.colors = const [Colors.blue, Colors.purple],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ).createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}

/// Animated Number Counter
class AnimatedCounter extends StatefulWidget {
  final int targetValue;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.targetValue,
    this.duration = const Duration(milliseconds: 1500),
    this.style,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = IntTween(
      begin: 0,
      end: widget.targetValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_animation.value}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}
