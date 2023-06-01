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
    print(UserInfo.primaryColor);
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent, //HexColor(userPrimaryColor),
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

class FriendMainAppBar extends MainAppBar {
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
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
