// filename: _search_button.dart
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class SearchButton extends StatefulWidget {
  final ValueChanged<String> onUpdateValue;
  const SearchButton({super.key, required this.onUpdateValue});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Expanded(
        child: TextField(
          onChanged: widget.onUpdateValue,
          textAlign: TextAlign.left, // Text aligns to the left
          decoration: InputDecoration(
            hintText: 'Search Task',
            hintStyle: const TextStyle(color: mainColor),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: mainColor, width: 1.0),
              borderRadius: BorderRadius.circular(32.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: mainColor, width: 1.0),
              borderRadius: BorderRadius.circular(32.0),
            ),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 50, minHeight: 50),
            suffixIcon: const Padding(
              padding: EdgeInsetsDirectional.only(end: 12.0),
              child: Icon(
                Icons.search,
                color: mainColor,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
