import 'package:flutter/material.dart';
import 'package:kamn/core/helpers/spacer.dart';
import 'package:kamn/core/theme/style.dart';

class CustomScreenHeader extends StatelessWidget {
  const CustomScreenHeader({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_circle_left_rounded)),
        verticalSpace(10),
        Text(
          title,
          style: TextStyles.fontCircularSpotify21BlackMedium,
        ),
        Text(
          subTitle,
          style: TextStyles.fontCircularSpotify8GrayRegular,
        ),
        verticalSpace(10),
      ],
    );
  }
}
