import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class MessageItem extends StatelessWidget {
  final String profilepic;
  final String name;
  final String message;
  final String time;
  final VoidCallback onTap;

  const MessageItem({
    super.key,
    required this.profilepic,
    required this.name,
    required this.message,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: ClipOval(
          child: Image.asset(
            profilepic,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: mainColor,
        ),
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
      onTap: onTap,
    );
  }
}
