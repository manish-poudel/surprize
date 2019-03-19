import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomCountDownTimerWidget extends StatefulWidget{

  Duration _duration;
  String _countDownString;

  CustomCountDownTimerWidget(this._duration, this._countDownString);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomCountDownTimerWidgetState(_duration,_countDownString);
  }

}

class CustomCountDownTimerWidgetState extends State<CustomCountDownTimerWidget> with TickerProviderStateMixin{

  Duration _duration;
  String _countDownString;

  CustomCountDownTimerWidgetState(this._duration, this._countDownString);
  AnimationController controller;


  String get timerString{
    Duration duration = controller.duration * controller.value;
    return '${(duration.inHours).toString().padLeft(2, '0')}: ${(duration.inMinutes.toString().padLeft(2, '0'))}: ${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }


  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration:_duration
    );
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      height: 180.0,
      width: 180.0,
      child: Padding(padding: EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Expanded(
              child:Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(aspectRatio: 1.0,
                    child:Stack(
                      children: <Widget>[
                        Positioned.fill(child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child){
                            return new CustomPaint(
                                painter: TimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color:Colors.blueAccent
                                )
                            );
                          },
                        )),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(_countDownString, style: TextStyle(color: Colors.green, fontSize: 18.0, fontFamily: 'Roboto')),
                              AnimatedBuilder(
                                  animation: controller,
                                  builder: (BuildContext context, Widget child){
                                    return new Text(
                                      timerString,
                                        style: TextStyle(color: Colors.white, fontSize: 32.0, fontFamily: 'Roboto')
                                    );
                                  }),
                            ],
                          ),
                        )
                      ],
                    )
                ),
              )
          ),
        ],),

      ),
    );
  }

}

class TimerPainter extends CustomPainter {

  final Animation<double> animation;
  final Color backgroundColor, color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      :super(repaint: animation);


  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    // TODO: implement shouldRepaint
    return animation.value != old.animation.value || color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}