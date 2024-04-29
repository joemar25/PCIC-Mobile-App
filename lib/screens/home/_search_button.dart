import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 45,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(5.0)),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Task',
          border: InputBorder.none,
          suffixIcon: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SvgPicture.asset('assets/storage/images/search.svg')),

          // contentPadding: EdgeInsets.zero,
        ),
      ),
    ));
  }
}
