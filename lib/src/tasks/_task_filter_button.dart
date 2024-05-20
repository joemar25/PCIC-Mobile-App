// filename: _task_filter_button.dart
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

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();

    return ElevatedButton(
      onPressed: () {
        showBottomSheet(
          elevation: 0.0,
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.5, color: Colors.black38),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 21.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F7D40),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter By:',
                          style: TextStyle(
                              fontSize: t?.title, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                              'assets/storage/images/close.svg'),
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
                            backgroundColor: const Color(0xFFD9F7FA),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.black38,
                                width: 0.5,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            'Ongoing',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: t?.overline,
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
                            backgroundColor: const Color(0xFFD9F7FA),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.black38,
                                width: 0.5,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            'For Dispatch',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: t?.overline,
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
                            backgroundColor: const Color(0xFFD9F7FA),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.black38,
                                width: 0.5,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: t?.overline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Sort By:',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
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
                                color: Colors.black38,
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
                              fontSize: t?.overline,
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
                                color: Colors.black38,
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
                              fontSize: t?.overline,
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
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(45, 45),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(
            color: Colors.black38,
            width: 0.5,
          ),
        ),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      child: SvgPicture.asset(
        'assets/storage/images/filter.svg',
        height: 35,
        width: 35,
      ),
    );
  }
}
