import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:simstock/constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  CustomButton({this.title,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: customButton(),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: 125,
          decoration: BoxDecoration(
            color: kleatherBrown,
          ),
          child: Text(title,textAlign: TextAlign.center,style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),),
        ),
      ),
    );
  }
}

class customButton extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    Paint paintStitches = Paint();
    paintStitches.style = PaintingStyle.stroke;
    paintStitches.color = Color(0xFF2b1d0e);
    paintStitches.strokeWidth = 2.0;
    paintStitches.strokeCap = StrokeCap.butt;

    Path pathStitches = Path();
    pathStitches.moveTo(size.width * 0.05, size.height * 0.1);
    pathStitches.lineTo(size.width * 0.05, size.height * 0.9);
    //pathStitches.quadraticBezierTo(size.width * 0.15, size.height * 0.85, size.width * 0.2, size.height * 0.9);
    pathStitches.lineTo(size.width * 0.95, size.height * 0.9);
    //pathStitches.quadraticBezierTo(size.width * 0.85, size.height * 0.85, size.width * 0.9, size.height * 0.8);
    pathStitches.lineTo(size.width * 0.95, size.height * 0.1);
    // pathStitches.quadraticBezierTo(size.width * 0.85, size.height * 0.15, size.width * 0.8, size.height * 0.1);
    pathStitches.lineTo(size.width * 0.05, size.height * 0.1);
    // pathStitches.quadraticBezierTo(size.width * 0.15, size.height * 0.15, size.width * 0.1, size.height * 0.2);

    canvas.drawPath(
      dashPath(
        pathStitches,
        dashArray: CircularIntervalList<double>(<double>[10.0, 6.5]),
      ),
      paintStitches,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


