import 'package:flutter/material.dart';

import '../theme.dart';
import 'teletext_text.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: AppColors.purple,
          strokeWidth: 2,
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          TeletextText(
            message!,
            style: const TextStyle(color: AppColors.purple),
          ),
        ],
      ],
    );
  }
}
