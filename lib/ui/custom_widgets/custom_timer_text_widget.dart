import 'package:flutter/cupertino.dart';

import '../../utils/Colors.dart';
import '../../utils/styles.dart';
import 'custom_common_text_widget.dart';

class CustomTimerTextWidget extends StatelessWidget {

  final String text;
  final int minutes;

  const CustomTimerTextWidget({
    super.key, required this.text, required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCommonTextWidget(
                  text:  text,
                  style: CommonTextStyle.regular_14,
                  color: colorPrimaryText,
              ),
              TweenAnimationBuilder(
                tween: Tween(
                    begin: Duration(minutes: minutes),
                    end: Duration.zero),
                duration: Duration(minutes: minutes),
                builder: (context, value, child) {
                  final minutes = value.inMinutes;
                  final seconds = value.inSeconds % 60;
                  return Text('$minutes:${seconds.toString().padLeft(2, '0')}');
                },
                onEnd: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}