import 'package:flutter/material.dart';
import 'package:surprize/CountDownTimerTypeEnum.dart';
import 'dart:math' as math;

class CustomCountDownTimerWidget extends StatefulWidget{

  Duration _duration;
  String _countDownString;
  double _height;
  double _width;
  Color _textColor;
  Color _circleColor;
  CountDownTimeTypeEnum _countDownTimeTypeEnum;

  CustomCountDownTimerWidget(this._duration, this._countDownString, this._height, this._width, this._textColor, this._circleColor, this._countDownTimeTypeEnum);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomCountDownTimerWidgetState(_duration,_countDownString, this._height, this._width, this._textColor, this._circleColor, this._countDownTimeTypeEnum);
  }

}

class CustomCountDownTimerWidgetState extends State<CustomCountDownTimerWidget> with TickerProviderStateMixin{

  Duration _duration;
  String _countDownString;
  double _height;
  double _width;
  Color _textColor;
  Color _circleColor;
  CountDownTimeTypeEnum _countDownTimeTypeEnum;

  CustomCountDownTimerWidgetState(this._duration, this._countDownString, this._height, this._width, this._textColor, this._circleColor, this._countDownTimeTypeEnum);
  AnimationController controller;


  String get timerString{
    Duration duration = controller.duration * controller.value;
    if(_countDownTimeTypeEnum == CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_NOT_AVAILABLE) {
      return '${(duration.inHours).toString().padLeft(2, '0')}: ${(duration
          .inMinutes.toString().padLeft(2, '0'))}: ${(duration.inSeconds % 60)
          .toString()
          .padLeft(2, '0')}';
    }

    if(_countDownTimeTypeEnum == CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_GAME_PLAY){
      return '${(duration.inSeconds % 60)
          .toString()
          .padLeft(2, '0')}';
    }

    return '${(duration.inHours).toString().padLeft(2, '0')}: ${(duration
        .inMinutes.toString().padLeft(2, '0'))}: ${(duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0')}';
  }

   List<Widget> getValue(){
     AnimatedBuilder builder =  AnimatedBuilder(
         animation: controller,
         builder: (BuildContext context, Widget child){
           return new Text(
               timerString,
               style: TextStyle(color: _textColor, fontSize: 32.0, fontFamily: 'Roboto')
           );
         });
    if(_countDownTimeTypeEnum == CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_GAME_PLAY){
      return [
          builder
      ];
    }
    return [
      Text(_countDownString, style: TextStyle(color: Colors.green, fontSize: 18.0, fontFamily: 'Roboto')),
        builder
    ];

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      height: _height,
      width: _width,
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
                                    color:_circleColor
                                )
                            );
                          },
                        )),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: getValue(),
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