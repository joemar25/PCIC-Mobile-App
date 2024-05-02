import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchButton extends StatefulWidget {
  final ValueChanged<String> onUpdateValue;
  const SearchButton({super.key, required this.onUpdateValue});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 45,
      decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(5.0)),
      child: TextField(
        onChanged: widget.onUpdateValue,
        decoration: InputDecoration(
          hintText: 'Search Task',
          border: InputBorder.none,
          suffixIcon: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SvgPicture.asset('assets/storage/images/search.svg')),
        ),
      ),
    ));
  }
}
