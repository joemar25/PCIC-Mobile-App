import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FilterButton extends StatefulWidget {
  final ValueChanged<bool> onUpdateState;
  final ValueChanged<String> onUpdateValue;
  const FilterButton(
      {super.key, required this.onUpdateState, required this.onUpdateValue});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool showComplete = false;

  void _setShowComplete(bool newState) {
    setState(() {
      showComplete = newState;
      widget.onUpdateState(showComplete);
    });
  }

  void _setOrderBy(String newValue) {
    widget.onUpdateValue(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext context) {
              return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 21.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filter By: ',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: SvgPicture.asset(
                                    'assets/storage/images/close.svg'))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _setShowComplete(false);
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFD9F7FA),
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              child: const Text(
                                'Current Task',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11.11,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _setShowComplete(true);
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF0F7D40),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text(
                                'Completed Task',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.11,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const Text('Sort By:',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                _setOrderBy('ID');
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text(
                                'ID',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11.11,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            TextButton(
                              onPressed: () {
                                _setOrderBy('Date Added');
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              child: const Text(
                                'Date Added',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11.11,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            TextButton(
                              onPressed: () {
                                _setOrderBy('Date Accessed');
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              child: const Text(
                                'Date Access',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11.11,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(45, 45),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: SvgPicture.asset(
        'assets/storage/images/filter.svg',
        height: 35,
        width: 35,
      ),
    );
  }
}
