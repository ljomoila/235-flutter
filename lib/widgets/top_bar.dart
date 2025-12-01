import 'package:flutter/material.dart';

import '../theme.dart';
import 'teletext_text.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key, this.title, this.onBack, this.actions});

  final String? title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack == null
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: onBack,
              tooltip: 'Back',
            ),
      title: title != null
          ? TeletextText(
              title!,
              style: const TextStyle(fontSize: 18, color: AppColors.white),
              textAlign: TextAlign.center,
            )
          : null,
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
