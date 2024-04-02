import 'package:flutter/material.dart';

class RecentTaskHeader extends StatelessWidget {
  const RecentTaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/storage/images/FormImage.png'),
                  height: 55,
                  width: 55,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Natural Disaster',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ID Number',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w100),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
