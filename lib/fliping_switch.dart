import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        title: 'test',
        home: FilpingSwitch(),
      ),
    );

class FilpingSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FlipingClock(
          color: Colors.amber,
          background: Colors.black,
          leftLabel: 'free'.toUpperCase(),
          rightLabel: 'premium'.toUpperCase(),
        ),
      ),
    );
  }
}

class FlipingClock extends StatefulWidget {
  FlipingClock({
    this.color = Colors.yellow,
    this.background = Colors.black,
    this.leftLabel = '',
    this.rightLabel = '',
  });

  final Color color;
  final Color background;
  final String leftLabel;
  final String rightLabel;

  @override
  _FlipingClockState createState() => _FlipingClockState();
}

class _FlipingClockState extends State<FlipingClock>
    with SingleTickerProviderStateMixin {
  int anim = 1;
  late AnimationController _flipController;

  late Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _jumpToMode(true);

    // timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
    //   setState(() {
    //     anim++;
    //     if (anim > 60) anim = 1;
    //   });
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _flipController.dispose(); // Animation Controller 폐기
    super.dispose();
  }

  void _jumpToMode(bool isLeft) {
    _flipController.value = isLeft ? 1.0 : 0.0;
  }

  void _flipSwitch() {
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildTabBackground(),
        AnimatedBuilder(
            animation: _flipController,
            builder: (context, child) {
              return _buildFlipingSwitch(pi * _flipController.value);
            }),
      ],
    );
  }

  Widget _buildTabBackground() {
    return GestureDetector(
      onTap: _flipSwitch,
      child: Container(
        width: 250,
        height: 64,
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: widget.color,
            width: 5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
                child: Center(
              child: Text(
                widget.leftLabel,
                style: TextStyle(
                    color: widget.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )),
            Expanded(
                child: Center(
              child: Text(
                widget.rightLabel,
                style: TextStyle(
                    color: widget.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipingSwitch(double angle) {
    final isLeft = angle > (pi / 2);
    final transformAngle = isLeft ? angle - pi : angle;

    return Positioned(
      top: 0,
      bottom: 0,
      right: isLeft ? null : 0,
      left: isLeft ? 0 : null,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(transformAngle),
        alignment:
            isLeft ? FractionalOffset(1.0, 1.0) : FractionalOffset(0, 1.0),
        child: Container(
          width: 125,
          height: 64,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.only(
              topRight: isLeft ? Radius.zero : Radius.circular(32),
              bottomRight: isLeft ? Radius.zero : Radius.circular(32),
              topLeft: isLeft ? Radius.circular(32) : Radius.zero,
              bottomLeft: isLeft ? Radius.circular(32) : Radius.zero,
            ),
            border: Border.all(
              width: 5,
              color: widget.color,
            ),
          ),
          child: Center(
            child: Text(
              isLeft ? widget.leftLabel : widget.rightLabel,
              style: TextStyle(
                color: widget.background,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
