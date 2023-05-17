import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'user_info/manage_preferences.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    print(UserInfo.primaryColor);
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: HexColor(UserInfo.primaryColor ?? "#FFFFFF"),
      title: Center(
        child: Text(
          "PicPals",
          style: GoogleFonts.getFont(
            'Varela Round',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
