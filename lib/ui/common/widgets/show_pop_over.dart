import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

void showPopMenuOver(
  BuildContext context,
  Widget body, {
  double width = 200,
  double height = 120,
  PopoverDirection direction = PopoverDirection.right,
  Color backgroundColor = Colors.white,
}) {
  showPopover(
    context: context,
    bodyBuilder: (context) => body,
    direction: direction,
    backgroundColor: backgroundColor,
    width: width,
    height: height,
    arrowHeight: 15,
    arrowWidth: 30,
  );
}
