import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        title: 'Flip Clock',
        home: FlipClock(),
        debugShowCheckedModeBanner: false,
      ),
    );

class FlipClock extends StatefulWidget {
  @override
  _FlipClockState createState() => _FlipClockState();
}

class _FlipClockState extends State<FlipClock> with TickerProviderStateMixin {
  late AnimationController secController,
      minController,
      hourController,
      amPmController;

  late Timer timer;

  int oldSec = 0;
  int oldMin = 0;
  int oldHour = 0;
  String oldAmPm = '';
  int newSec = 0;
  int newMin = 0;
  int newHour = 0;
  String newAmPm = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    secController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    minController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    hourController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    amPmController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    var date = DateTime.now();
    oldSec = newSec = date.second;
    oldMin = newMin = date.minute;
    oldHour = newHour = date.hour;
    oldAmPm = newAmPm = date.hour > 12 ? 'PM' : 'AM';

    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        var curDate = DateTime.now();
        // sec 설정
        if (secController.isCompleted) {
          secController.value = 0;
          oldSec = newSec;
        }
        if (newSec != curDate.second) {
          newSec = curDate.second;
          secController.forward();
        }
        // min 설정
        if (minController.isCompleted) {
          minController.value = 0;
          oldMin = newMin;
        }
        if (newMin != curDate.minute) {
          newMin = curDate.minute;
          minController.forward();
        }
        // hour 설정
        if (hourController.isCompleted) {
          hourController.value = 0;
          oldHour = newHour;
        }
        if (newHour != curDate.hour) {
          newHour = curDate.hour;
          hourController.forward();
        }

        // amPm 설정
        // if (amPmController.isCompleted) {
        //   hourController.value = 0;
        //   oldAmPm = oldAmPm;
        // }
        // if (newAmPm != (date.hour > 12 ? 'PM' : 'AM')) {
        //   newAmPm = (date.hour > 12 ? 'PM' : 'AM');
        //   amPmController.forward();
        // }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    secController.dispose();
    minController.dispose();
    hourController.dispose();
    amPmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlippingClock(
              width: 300,
              height: 300,
              color: Colors.white,
              bgColor: Colors.grey[900]!,
              animController: hourController,
              oldTime: oldHour < 10 ? '0$oldHour' : '$oldHour',
              newTime: newHour < 10 ? '0$newHour' : '$newHour',
            ),
            SizedBox(
              width: 10,
            ),
            FlippingClock(
              width: 300,
              height: 300,
              color: Colors.white,
              bgColor: Colors.grey[900]!,
              animController: minController,
              oldTime: oldMin < 10 ? '0$oldMin' : '$oldMin',
              newTime: newMin < 10 ? '0$newMin' : '$newMin',
            ),
            SizedBox(
              width: 10,
            ),
            FlippingClock(
              width: 100,
              height: 100,
              color: Colors.white,
              bgColor: Colors.grey[900]!,
              animController: secController,
              oldTime: oldSec < 10 ? '0$oldSec' : '$oldSec',
              newTime: newSec < 10 ? '0$newSec' : '$newSec',
            ),
          ],
        ),
      ),
    );
  }
}

class FlippingClock extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final Color bgColor;
  final AnimationController animController;
  final String oldTime;
  final String newTime;

  FlippingClock({
    required this.width,
    required this.height,
    required this.color,
    required this.bgColor,
    required this.animController,
    required this.oldTime,
    required this.newTime,
  });

  @override
  _FlippingClockState createState() => _FlippingClockState();
}

class _FlippingClockState extends State<FlippingClock> {
  late final textSize;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textSize = widget.width / 2 * 1.5;
    _jumpToMode(false);
  }

  void _jumpToMode(bool isFlip) {
    widget.animController.value = isFlip ? 1.0 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildClockBackground(),
        AnimatedBuilder(
          animation: widget.animController,
          builder: (context, child) =>
              _buildFlipingClock(pi * widget.animController.value),
        ),
      ],
    );
  }

  Widget _buildClockBackground() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 10,
          color: Colors.black,
        )
      ]),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: widget.height / 10 - widget.height / 25,
                    child: _textStyle(widget.newTime),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: widget.height / 50,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: widget.height / 10 - widget.height / 25,
                    child: _textStyle(widget.oldTime),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textStyle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFlipingClock(double angle) {
    final isFlip = angle > (pi / 2);
    final transformAngle = isFlip ? angle - pi : angle;

    return Positioned(
      top: isFlip ? null : 0.0,
      bottom: isFlip ? 0.0 : null,
      left: 0,
      right: 0,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(transformAngle),
        alignment: isFlip
            ? FractionalOffset(0.5, -0.025)
            : FractionalOffset(0.5, 1.025),
        child: Container(
          width: widget.width,
          height: widget.height / 2 - widget.height / 100,
          alignment: isFlip ? Alignment.topCenter : Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            // color: Colors.amber,
            borderRadius: BorderRadius.only(
              topLeft:
                  isFlip ? const Radius.circular(0) : const Radius.circular(10),
              topRight:
                  isFlip ? const Radius.circular(0) : const Radius.circular(10),
              bottomLeft:
                  isFlip ? const Radius.circular(10) : const Radius.circular(0),
              bottomRight:
                  isFlip ? const Radius.circular(10) : const Radius.circular(0),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: isFlip ? null : widget.height / 10 - widget.height / 25,
                bottom: isFlip ? widget.height / 10 - widget.height / 25 : null,
                child: _textStyle(isFlip ? widget.newTime : widget.oldTime),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
