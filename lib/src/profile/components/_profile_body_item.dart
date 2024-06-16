// src/profile/components/_profile_body_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/_theme.dart';

class ProfileBodyItem extends StatefulWidget {
  final String label;
  final String svgPath;
  const ProfileBodyItem(
      {super.key, required this.label, required this.svgPath});

  @override
  State<ProfileBodyItem> createState() => _ProfileBodyItemState();
}

class _ProfileBodyItemState extends State<ProfileBodyItem> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.svgPath,
              height: 35,
              width: 35,
              colorFilter: ColorFilter.mode(
                  widget.label == 'Logout' ? Colors.red : Colors.black,
                  BlendMode.srcIn),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              widget.label,
              style: TextStyle(
                  color: widget.label == 'Logout' ? Colors.red : null,
                  fontSize: t?.body,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        if (widget.label != 'Logout')
          SvgPicture.asset(
            'assets/storage/images/chevron-right.svg',
            height: 30,
            width: 30,
          ),
      ],
    );
  }
}
