// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';

import '../utils/color_constants.dart';

class DefaultWhiteButton extends StatelessWidget {
  String text;
  final Function() press;
  DefaultWhiteButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 335,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColorDark, width: 1),
            boxShadow: [
              BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))
            ],
            color: white,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColorDark),
          ),
        ),
      ),
    );
  }
}
