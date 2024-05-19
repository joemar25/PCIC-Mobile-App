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
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: TextField(
                  onChanged: widget.onUpdateValue,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Search Task',
                    hintStyle:
                        TextStyle(color: Colors.grey, fontSize: t?.caption),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 45, minHeight: 50),
                    suffixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(end: 12.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.black38,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
