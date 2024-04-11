import 'package:flutter/material.dart';
import 'package:giku/app/theme/custom_theme.dart';

class WidgetRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            child: WaveWidget(color: CustomTheme.blueColor3, height: w * 0.7),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            child: WaveWidget(color: CustomTheme.blueColor2, height: w * 0.6),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            child: WaveWidget(color: CustomTheme.blueColor1, height: w * 0.5),
          ),
        ),
        Positioned(
          top: w * 0.1,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/other/logoMywidget.png',
            width: w * 0.5,
            height: w * 0.5,
          ),
        ),
      ],
    );
  }
}

class WaveWidget extends StatelessWidget {
  final Color color;
  final double height;

  const WaveWidget({Key? key, required this.color, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: CustomPaint(
        painter: ConcaveShapePainter(color: color),
      ),
    );
  }
}

class ConcaveShapePainter extends CustomPainter {
  final Color color;

  ConcaveShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width, size.height * 0.96); // Mulai dari sisi kanan bawah

    // Kurva pertama menuju ke kiri
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.95,
      size.width * 0.8,
      size.height * 0.83,
    );

    // Cekung ke atas dan kiri
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.45,
      size.width * 0.2,
      size.height * 0.83,
    );

    // Kurva terakhir menuju ke kanan
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.95,
      0,
      size.height * 0.96,
    );

    // Garis ke sisi kiri atas
    path.lineTo(0, 0);
    // Garis ke sisi kanan atas
    path.lineTo(size.width, 0);
    path.close(); // Menghubungkan kembali ke titik awal

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
