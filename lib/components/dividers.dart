// Small shared separators used to divide details in the themed interface.
import 'package:flutter/material.dart';
import 'package:gmdex/theme/apptheme.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.primary, thickness: 1);
  }
}

// Kept as a reference for a custom vertical separator if a future layout needs
// one; current screens use horizontal rules only.
// class VerticalDivider extends StatelessWidget {
//   const VerticalDivider({super.key, required this.height});

//   final double height;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: 5,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(right: BorderSide(color: AppColors.primary, width: 1)),
//         ),
//       ),
//     );
//   }
// }