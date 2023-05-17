import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_info/manage_preferences.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  var userPrimaryColor = "#0d1b2a";
  var userSecondaryColor = "#1b263b";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      userPrimaryColor = prefs.getString('primaryColor') ?? '#FFFFFF';
      userSecondaryColor = prefs.getString('secondaryColor') ?? '#FFFFFF';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HexColor(userPrimaryColor),
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
