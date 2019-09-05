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
  CustomCountDownTimerWidgetState _state;
  bool _startCountDownImmediately;

  /*
  Start countdown
   */
  void startCountdown(){
    if(_state != null) {
      _state._startController();
    }
  }

  /*
  stop countdown
   */
  void stopCountdown(){
    _state._stopController();
  }

  void resetCountdown(){
    _state._resetController();
  }

  void repeatCountdown(){
    _state._repeatController();
  }

  CustomCountDownTimerWidget(this._startCountDownImmediately,this._duration, this._countDownString, this._height, this._width, this._textColor, this._circleColor, this._countDownTimeTypeEnum);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    _state =  CustomCountDownTimerWidgetState( _duration,_countDownString, this._height, this._width, this._textColor, this._circleColor, this._countDownTimeTypeEnum);
    return _state;
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
      print("Duration in minute" + (duration.inMinutes).toString());
      return '${(duration.inHours).toString().padLeft(2, '0')}: ${((duration
          .inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0'))}: ${(duration.inSeconds % 60)
          .toString()
          .padLeft(2, '0')}';
    }

    if(_countDownTimeTypeEnum == CountDownTimeTypeEnum.DAILY_QUIZ_CHALLENGE_GAME_PLAY){
      return '${(duration.inSeconds % 60)
          .toString()
          .padLeft(2, '0')}';
    }

    return '${(duration.inHours).toString().padLeft(2, '0')}: ${(duration
        .inMinutes.toString().padLeft(2, '0'))}: ${(duration.inSeconds)
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
      Text(_countDownString, style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Roboto', fontWeight: FontWeight.w400)),
        builder
    ];

  }


  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration:_duration.isNegative?Duration(seconds: 0):_duration
    );

    if(widget._startCountDownImmediately) {
      _startController();
    }
  }

  /*
  Start controller
   */
  void _startController(){
    try {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }
    catch(error){
      controller = AnimationController(
          vsync: this,
          duration:Duration(seconds:0));
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);

    }
  }

  /*
  stop controller
   */
  void _stopController(){
    controller.stop();
  }

  /*
  Reset controller
   */
  void _resetController(){
    controller.reset();
  }

  /*
  Repeat controller
   */
  void _repeatController(){
    controller.repeat();
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