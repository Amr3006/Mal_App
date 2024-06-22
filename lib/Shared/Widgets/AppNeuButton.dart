import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppNeuButton extends StatefulWidget {

  final double? height;
  final double? width;
  final Color backgroundColor;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final Color shadowColor;
  final void Function() onPress;

  const AppNeuButton({
    super.key,
    this.height,
    this.width,
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black,
    this.child,
    this.borderRadius,
     required this.onPress
  });


  @override
  State<AppNeuButton> createState() => _AppNeuButtonState();
}

class _AppNeuButtonState extends State<AppNeuButton> {
  var margin = const EdgeInsets.only(left: 0, top: 0, right: 6);
  var offset = const Offset(6, 6);
  late final double? height;
  late final double? width;
  late final Color backgroundColor;
  late final Widget? child;
  late final BorderRadiusGeometry? borderRadius;
  late final Color shadowColor;
  late final void Function() onPress;

  @override
  void initState() {
    height = widget.height;
    shadowColor = widget.shadowColor;
    width = widget.width;
    onPress = widget.onPress;
    backgroundColor = widget.backgroundColor;
    child=widget.child;
    borderRadius = widget.borderRadius;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          offset = const Offset(0, 0);
          margin = const EdgeInsets.only(left: 6, top: 6, right: 0);
        });
        await Future.delayed(const Duration(milliseconds: 65));
        setState(() {
          margin = const EdgeInsets.only(left: 0, top: 0, right: 6);
          offset = const Offset(6, 6);
        });

        onPress();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 65),
          height: height,
          width: width,
          margin: margin,
          decoration: BoxDecoration(
            border: Border.all(width: 3),
            borderRadius: borderRadius,
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                offset: offset,
                color: shadowColor
              )
            ]
          ),
          child: child,
        ),
      ),
    );
  }
}