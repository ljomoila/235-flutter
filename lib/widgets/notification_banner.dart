import 'package:flutter/material.dart';

import '../theme.dart';
import 'teletext_text.dart';

enum NoticeType { error, success, info }

class NotificationBanner extends StatelessWidget {
  const NotificationBanner({
    super.key,
    required this.message,
    this.type = NoticeType.error,
  });

  final String message;
  final NoticeType type;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red;
    switch (type) {
      case NoticeType.success:
        color = AppColors.green;
        break;
      case NoticeType.info:
        color = AppColors.blue;
        break;
      case NoticeType.error:
        color = Colors.red;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.6)),
        color: color.withValues(alpha: 0.08),
      ),
      child: TeletextText(message, style: TextStyle(color: color)),
    );
  }
}
