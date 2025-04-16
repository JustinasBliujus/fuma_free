import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fuma_free/assets/global/colours.dart';

class GrowingButton extends StatefulWidget {
  const GrowingButton({super.key});

  @override
  State<GrowingButton> createState() => _GrowingButtonState();
}

class _GrowingButtonState extends State<GrowingButton> {
  double circleSize = 100;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        checkAndAdjust();
      });
    });
  }

  void checkAndAdjust(){
    if(circleSize > 100){
      circleSize -= 1;
    }
    if(circleSize > 150){
      circleSize -= 2;
    }
    else if(circleSize > 200){
      circleSize -= 5;
    }else if(circleSize > 250){
      circleSize -= 10;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                circleSize += 3;
              });
            },
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Center(
                child: Icon(
                  Icons.touch_app,
                  color: AppColors.textSecondary,
                  size: 50.0,
                ),
              ),
            ),
          ),
        ),
    );
  }
}
