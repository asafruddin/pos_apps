import 'package:flutter/material.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 5,
      thickness: 5.0,
      color: CustomTheme.neutral200,
    );
  }
}
