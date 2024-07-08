import 'package:flutter/material.dart';

class AppBars extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBars({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [
      //         hexStringToColor("cc9880"),
      //         hexStringToColor("c71565"),
      //         hexStringToColor("333337"),
      //       ],
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //     ),
      //   ),
      // ),
      backgroundColor: const Color(0xffc71565),
      foregroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}
