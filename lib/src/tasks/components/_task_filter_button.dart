import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class FilterButton extends StatefulWidget {
  final ValueChanged<String> onUpdateState;
  final ValueChanged<String> onUpdateValue;

  const FilterButton({
    super.key,
    required this.onUpdateState,
    required this.onUpdateValue,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  void _setFilter(String newState) {
    widget.onUpdateState(newState);
  }

  void _setOrderBy(String newValue) {
    widget.onUpdateValue(newValue);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter By:',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .extension<CustomThemeExtension>()
                              ?.title,
                          fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child:
                          SvgPicture.asset('assets/storage/images/close.svg'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _setFilter('Ongoing');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF87CEFA),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'Ongoing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Theme.of(context)
                              .extension<CustomThemeExtension>()
                              ?.overline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    TextButton(
                      onPressed: () {
                        _setFilter('For Dispatch');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4500),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'For Dispatch',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Theme.of(context)
                              .extension<CustomThemeExtension>()
                              ?.overline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    TextButton(
                      onPressed: () {
                        _setFilter('Completed');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Theme.of(context)
                              .extension<CustomThemeExtension>()
                              ?.overline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Sort By:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _setOrderBy('Date Added');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFD9F7FA),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'Date Added',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Theme.of(context)
                              .extension<CustomThemeExtension>()
                              ?.overline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    TextButton(
                      onPressed: () {
                        _setOrderBy('Date Accessed');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFD9F7FA),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 0.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'Date Access',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Theme.of(context)
                              .extension<CustomThemeExtension>()
                              ?.overline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showFilterDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(45, 45),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 3, // Custom elevation for shadow effect
        shadowColor: Colors.grey.withOpacity(0.7), // Custom shadow color
      ),
      child: SvgPicture.asset(
        'assets/storage/images/filter.svg',
        color: mainColor,
        height: 35,
        width: 35,
      ),
    );
  }
}
