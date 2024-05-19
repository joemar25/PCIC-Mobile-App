import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class SearchButton extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onUpdateValue;

  const SearchButton({
    super.key,
    required this.searchQuery,
    required this.onUpdateValue,
  });

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchQuery;
  }

  @override
  void didUpdateWidget(SearchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onUpdateValue,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Search Task...',
                    hintStyle: const TextStyle(color: mainColor),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: mainColor, width: 1.0),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: mainColor, width: 1.0),
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
          ),
        ],
      ),
    );
  }
}
