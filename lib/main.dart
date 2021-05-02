import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(FlipClock());

class FlipClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlipClock',
      home: AnimatedFlipClock(),
    );
  }
}

class AnimatedFlipClock extends StatefulWidget {
  @override
  _AnimatedFlipClockState createState() => _AnimatedFlipClockState();
}

class _AnimatedFlipClockState extends State<AnimatedFlipClock> {
  DateTime time = new DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        time = new DateTime.now();
      });
    });
  }

  @override
  void deactivate() {
    _timer.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width / 5;
    double height = size.height / 3;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: Icon(Icons.refresh),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildClock(width, height, time.hour),
            SizedBox(
              width: 10,
            ),
            _buildClock(width, height, time.minute),
            SizedBox(
              width: 10,
            ),
            _buildClock(width, height, time.second)
          ],
        ),
      ),
    );
  }

  Stack _buildClock(double width, double height, int time) {
    const double radius = 5;
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                    )),
              ),
              SizedBox(
                height: height / 30,
              ),
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    )),
              ),
            ],
          ),
        ),
        Text(
          '$time',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: width - 50,
          ),
        )
      ],
    );
  }
}
