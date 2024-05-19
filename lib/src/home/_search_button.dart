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
                  controller: _controller,
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
