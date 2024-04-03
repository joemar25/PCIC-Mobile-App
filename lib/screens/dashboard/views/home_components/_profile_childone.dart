import 'package:flutter/material.dart';

class ProfileChildOne extends StatelessWidget {
  const ProfileChildOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/storage/images/icon.png'),
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
                      'Juan Dela Cruz',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Agent 007',
                      style: TextStyle(
                          color: Color(0xFFD2FFCB),
                          fontWeight: FontWeight.w100),
                    )
                  ],
                ),
              ],
            ),
          ),
          Image(image: AssetImage('assets/storage/images/arrow-right.png'))
        ],
      ),
    );
  }
}
