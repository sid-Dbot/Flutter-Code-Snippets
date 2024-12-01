import 'package:flutter/material.dart';

class CustomCurvedBottomNav extends StatelessWidget {
  final List<Widget> items;
  final Color color;
  final Color shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final double cornerRadius, curve;
  CustomCurvedBottomNav(
      {required this.items,
      this.color = Colors.white,
      this.shadowColor =
          const Color(0x55000000), // Default semi-transparent black
      this.shadowBlur = 10.0,
      this.shadowOffset = const Offset(4, 4),
      this.cornerRadius = 40,
      this.curve = 45});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 70),
            painter: CurvedPainter(
                cornerRadius: cornerRadius,
                curve: curve,
                shadowColor: shadowColor,
                color: color,
                shadowOffset: shadowOffset,
                shadowBlur: shadowBlur),

            // foregroundPainter: CurvedPainter(),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items,
            ),
          ),
        )
      ],
    );
  }

  Widget BottomNavItem(
      {required IconData icon,
      required String label,
      required ontap,
      Color color = Colors.grey}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        radius: 40, borderRadius: BorderRadius.circular(40),
        // splashColor: Colors.amber,
        onTap: ontap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 30,
                color: color,
              ),
              Text(
                '$label',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Color clor;
  const CustomContainer({super.key, this.clor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: clor,
    );
  }
}

class CurvedPainter extends CustomPainter {
  final Color color;
  final Color shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final double cornerRadius, curve;

  CurvedPainter(
      {required this.color,
      this.shadowColor =
          const Color(0x55000000), // Default semi-transparent black
      this.shadowBlur = 10.0,
      this.shadowOffset = const Offset(4, 4),
      this.cornerRadius = 40,
      this.curve = 45});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    final Path path = Path();

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 10, cornerRadius, 0);
    path.quadraticBezierTo(
        size.width * 0.5, -curve, size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 10, size.width, cornerRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cornerRadius);
    path.close();

    // Draw the shadow (offset by shadowOffset)
    canvas.save();
    canvas.translate(shadowOffset.dx, shadowOffset.dy);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw the actual shape
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
