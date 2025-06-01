import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BaseLoadingAnimation extends StatelessWidget {
  const BaseLoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  LoadingAnimationWidget.fourRotatingDots(
        color: Colors.white, size: 25);
  }
}