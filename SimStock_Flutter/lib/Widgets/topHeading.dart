import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:simstock/constants.dart';

class TopHeading extends StatelessWidget {
  final String title;
  TopHeading({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(title,textAlign: TextAlign.center,style: TextStyle(
            color: Colors.white,
            fontSize: 50
        ),),
        Divider(
          thickness: 3.0,
          endIndent: MediaQuery.of(context).size.width * 0.40,
          indent: MediaQuery.of(context).size.width * 0.40,
          color: Colors.white.withOpacity(0.5),
        ),
      ],
    );
  }
}



// Custom Painter class to paint the curved shape

class appBarBackground extends CustomPainter{

  final bool isStitched;
  final Color curveFillColor;
  final Color stitchColor;
  appBarBackground({this.curveFillColor = kleatherBrown,this.isStitched = true,this.stitchColor = kstitchColor});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = curveFillColor;

    canvas.drawColor(kbackgroundBlue, BlendMode.dstATop);

    // Painting the base brown leather curve pattern
    Path path = Path();
    path.moveTo(0, size.height * 0.05);
    path.conicTo((size.width * 0.25)/2 , size.height * 0.05, size.width * 0.25,size.height * 0.15, 0.5);
    path.quadraticBezierTo((size.width * 0.25)/4 , size.height * 0.05, size.width * 0.25,size.height * 0.15);
    path.quadraticBezierTo((size.width)/2 , size.height * 0.30, size.width * 0.75,size.height * 0.15);
    path.conicTo((size.width * 0.75) + (size.width * 0.25)/2 , size.height * 0.05, size.width,size.height * 0.05,0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
    if(isStitched) {
      // Painting the stitches on the heading
      Paint paintStitches = Paint();
      paintStitches.style = PaintingStyle.stroke;
      paintStitches.color = stitchColor;
      paintStitches.strokeWidth = 3.0;
      paintStitches.strokeCap = StrokeCap.butt;

      Path pathStitches = Path();
      pathStitches.moveTo(0, size.height * 0.04);
      pathStitches.conicTo(
          (size.width * 0.25) / 2, size.height * 0.04, size.width * 0.25,
          size.height * 0.14, 0.5);
      pathStitches.quadraticBezierTo(
          (size.width) / 2, size.height * 0.29, size.width * 0.75,
          size.height * 0.14);
      pathStitches.conicTo(
          (size.width * 0.75) + (size.width * 0.25) / 2, size.height * 0.04,
          size.width, size.height * 0.04, 0.5);

      canvas.drawPath(
        dashPath(
          pathStitches,
          dashArray: CircularIntervalList<double>(<double>[15.0, 10.5]),
        ),
        paintStitches,
      );
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}
