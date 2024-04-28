import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextField(
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
          hintText: 'Search Task',
          hintStyle: const TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.grey),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SvgPicture.asset(
              'assets/storage/images/search.svg',
              height: 28,
              width: 28,
            ),
          ),
        ),
      ),
    );
  }
}
