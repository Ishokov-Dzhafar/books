import 'package:flutter/material.dart';

class PasscodeIndicator extends StatelessWidget {
  final int totalCount;
  final int filledCount;
  final Color filledColor;
  final Color disabledColor;

  PasscodeIndicator(
      {@required this.totalCount,
      @required this.filledCount,
      @required this.filledColor,
      @required this.disabledColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < totalCount; i++)
          if (i < filledCount)
            Icon(
              Icons.fiber_manual_record,
              color: filledColor,
            )
          else
            Icon(
              Icons.fiber_manual_record,
              color: disabledColor,
            )
      ],
    );
  }
}
