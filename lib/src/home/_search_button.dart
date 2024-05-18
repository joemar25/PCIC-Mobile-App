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
      child: Container(
        // Added Container for the shadow effect
        decoration: BoxDecoration(
          color: Colors.white, // Added white background color
          borderRadius: BorderRadius.circular(32.0), // Added rounded edges
          boxShadow: [
            // Added BoxShadow for subtle shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Subtle shadow color
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(32.0), // Clip the child to rounded edges
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
      ),
    );
  }
}
