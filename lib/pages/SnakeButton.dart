import 'package:flutter/material.dart';

class SnakeAnimation extends StatefulWidget {
  const SnakeAnimation({super.key});

  @override
  State<SnakeAnimation> createState() => _SnakeAnimationState();
}

class _SnakeAnimationState extends State<SnakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      _controller..repeat(reverse: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Snake Animation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: SnakeBorderPainter(_animation.value),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Animation',style: TextStyle(color: Colors.white),),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SnakeBorderPainter extends CustomPainter {
  final double progress;

  SnakeBorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red, Colors.blue, Colors.green],
        stops: [0.0, 0.5, 1.0],
        transform: GradientRotation(progress * 2 * 3.141592653589793),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double borderLength = 2 * size.width + 2 * size.height;
    final double currentPosition = borderLength * progress;
    final double snakeLength = borderLength / 10; // Length of the snake segment

    final Path path = Path();
    path.moveTo(0, 0);

    if (currentPosition < size.width) {
      path.lineTo(currentPosition, 0);
    } else if (currentPosition < size.width + size.height) {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, currentPosition - size.width);
    } else if (currentPosition < 2 * size.width + size.height) {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(2 * size.width + size.height - currentPosition, size.height);
    } else {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, borderLength - currentPosition);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}