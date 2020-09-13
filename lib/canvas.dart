import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _downCounter = 0;
  int _upCounter = 0;

  double x = 0.0;
  double y = 0.0;
  List<Offset> _points = <Offset>[];

  void _pointerDown(PointerEvent details) {
    _pointerMove(details);
    setState(() {
      _downCounter++;
    });
  }

  void _pointerUp(PointerEvent details) {
    _pointerMove(details);
    setState(() {
      _upCounter++;
    });
  }

  void _pointerMove(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
      setState(() {
        RenderBox referenceBox = context.findRenderObject();
        Offset localPosition = details.localPosition;
        _points = List.from(_points)..add(localPosition);
      });
    });
  }

  void _pointerCancel(PointerEvent details) {

  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(300.0, 200.0)),
      child: Listener(
        onPointerDown: _pointerDown,
        onPointerMove: _pointerMove,
        onPointerUp: _pointerUp,
        onPointerCancel: _pointerCancel,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
              size: Size.infinite,
              painter: CanvasPainter(_points)
          ),
        ),
      ),
    );
  }
}

class CanvasPainter extends CustomPainter{
  List<Offset> points = <Offset>[];
  Paint _paint = new Paint()
    ..color = Colors.black
    ..strokeWidth = 4.0;

  CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], _paint);
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) {
    return oldDelegate.points != points;
  }

}