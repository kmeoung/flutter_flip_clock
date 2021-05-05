import 'dart:async';
import 'dart:math';

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
      backgroundColor: Colors.grey,
      body: Center(
        child: FlipingClock(
          width: 100,
          height: 100,
          color: Colors.black,
          bgColor: Colors.white,
        ),
      ),
    );
  }
}

class FlipingClock extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final Color bgColor;

  FlipingClock({
    required this.width,
    required this.height,
    required this.color,
    required this.bgColor,
  });

  @override
  _FlipingClockState createState() => _FlipingClockState();
}

class _FlipingClockState extends State<FlipingClock> {
  late Timer? timer;
  late int anim;
  @override
  void initState() {
    // TODO: implement initState
    anim = 1;
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        anim++;
        if (anim > 30) anim = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildClockBackground(),
        _buildFlipingClock(anim / 30 * pi),
      ],
    );
  }

  Widget _buildClockBackground() {
    return Container(
      width: widget.width,
      height: widget.height * 2 + 2,
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
                  topLeft: Radius.circular(widget.width / 10),
                  topRight: Radius.circular(widget.width / 10),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(widget.width / 10),
                  bottomRight: Radius.circular(widget.width / 10),
                ),
              ),
            ),
          ),
        ],
      ),
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
        alignment:
            isFlip ? FractionalOffset(0.5, 0.0) : FractionalOffset(0.5, 1.01),
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: isFlip ? Alignment.topCenter : Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(
              topLeft: isFlip
                  ? Radius.circular(0)
                  : Radius.circular(widget.width / 10),
              topRight: isFlip
                  ? Radius.circular(0)
                  : Radius.circular(widget.width / 10),
              bottomLeft: isFlip
                  ? Radius.circular(widget.width / 10)
                  : Radius.circular(0),
              bottomRight: isFlip
                  ? Radius.circular(widget.width / 10)
                  : Radius.circular(0),
            ),
          ),
          child: Text(
            isFlip ? '24' : '23',
            style: TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }
}
