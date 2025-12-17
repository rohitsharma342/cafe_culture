import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/app_constants.dart';

class LoadingAnimation extends StatelessWidget {
  final double size;
  final Color? color;
  
  const LoadingAnimation({
    super.key,
    this.size = 40.0,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? AppConstants.primaryColor,
      size: size,
    );
  }
}