import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.all(18),
            backgroundColor: Color(0xFFF5F6F9),
            primary: Colors.black.withOpacity(0.5)),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: Colors.black.withOpacity(0.5),
              width: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
