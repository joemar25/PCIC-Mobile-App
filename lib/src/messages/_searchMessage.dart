import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class SearchMessageButton extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onUpdateValue;

  const SearchMessageButton({
    super.key,
    required this.searchQuery,
    required this.onUpdateValue,
  });

  @override
  State<SearchMessageButton> createState() => _SearchMessageButtonState();
}

class _SearchMessageButtonState extends State<SearchMessageButton> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchQuery;
  }

  @override
  void didUpdateWidget(SearchMessageButton oldWidget) {
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
                  onChanged: (value) {
                    widget.onUpdateValue(value);
                    setState(() {
                      _isSearching = value.isNotEmpty;
                    });
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Search Message',
                    hintStyle:
                        TextStyle(color: Colors.grey, fontSize: t?.caption),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
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
                    suffixIcon: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12.0),
                      child: _isSearching
                          ? Lottie.asset(
                              'assets/animations/search.json',
                              width: 45,
                              height: 45,
                            )
                          : const Icon(
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
