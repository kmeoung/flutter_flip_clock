import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        title: 'Flip Clock',
        home: FlipClock(),
      ),
    );

class FlipClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FlippingClock(
          width: 500,
          height: 500,
          color: Colors.white,
          bgColor: Colors.grey[900]!,
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

  FlippingClock({
    required this.width,
    required this.height,
    required this.color,
    required this.bgColor,
  });

  @override
  _FlippingClockState createState() => _FlippingClockState();
}

class _FlippingClockState extends State<FlippingClock> {
  late Timer? timer;
  late int anim;
  late final textSize;

  @override
  void initState() {
    // TODO: implement initState
    anim = 1;
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        anim++;
        if (anim > 60) anim = 1;
      });
    });
    textSize = widget.width / 2 * 1.5;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer != null) timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildClockBackground(),
        _buildFlipingClock(anim / 60 * pi),
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
                    child: _textStyle('59'),
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
                    child: _textStyle('58'),
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
          ..setEntry(3, 2, 0.001)
          ..rotateX(transformAngle),
        alignment:
            isFlip ? FractionalOffset(0.5, 0.0) : FractionalOffset(0.5, 1.01),
        child: Container(
          width: widget.width,
          height: widget.height / 2,
          alignment: isFlip ? Alignment.topCenter : Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.grey[900],
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
                child: _textStyle(isFlip ? '59' : '58'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
