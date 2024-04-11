import 'package:flutter/material.dart';
import 'package:giku/app/theme/custom_theme.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            child: WaveWidget(color: CustomTheme.blueColor3, height: w * 0.8),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            child: WaveWidget(color: CustomTheme.blueColor2, height: w * 0.73),
          ),
        ),
        Positioned(
          bottom: w * 0.38,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/other/logoMywidget.png',
            width: w * 0.5,
            height: w * 0.5,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            child: WaveWidget(color: CustomTheme.white, height: w * 0.66),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            child: WaveWidget(color: CustomTheme.blueColor1, height: w * 0.65),
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
    path.moveTo(0, size.height * 0.04); // Mulai dari sisi kiri atas

    // Kurva pertama menuju ke kanan
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.05,
      size.width * 0.2,
      size.height * 0.17,
    );

    // Cekung ke atas dan kanan
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.55,
      size.width * 0.8,
      size.height * 0.17,
    );

    // Kurva terakhir menuju ke kiri
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.05,
      size.width,
      size.height * 0.04,
    );

    // Garis ke sisi kanan bawah
    path.lineTo(size.width, size.height);
    // Garis ke sisi kiri bawah
    path.lineTo(0, size.height);
    path.close(); // Menghubungkan kembali ke titik awal

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
