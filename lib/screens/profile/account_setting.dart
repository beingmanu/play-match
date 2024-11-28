import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import '../../services/auth_service.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/snackbar.dart';
import '../../widgets/basic_container.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../auth/login_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicScafold(
      title: "Account Settings",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            tileWidget("Mobile number", subtitle: "+91 8003640336"),
            tileWidget("Email", subtitle: "manishsapela07@gmail.com"),
            const BasicOutLineContainer(
              padding: EdgeInsets.zero,
            ),
            tileWidget("Gender",
                icon: FontAwesomeIcons.mars, subtitle: "he/him"),
            tileWidget("Location",
                icon: FontAwesomeIcons.locationArrow, subtitle: "udaipur"),
            tileWidget("Instagram",
                icon: FontAwesomeIcons.instagram, subtitle: "@beingme"),
            tileWidget("Partner",
                icon: FontAwesomeIcons.heart, subtitle: "@beingme"),
            tileWidget("Date of Birth",
                icon: FontAwesomeIcons.calendar, subtitle: "3 May / 25 years"),
            tileWidget("Occupation",
                icon: FontAwesomeIcons.briefcase, subtitle: "Developer"),
            const BasicOutLineContainer(
              padding: EdgeInsets.zero,
            ),
            tileNpagewidget("BFFs"),
            tileNpagewidget("Interests"),
            tileNpagewidget("Favroit Games"),
            tileNpagewidget("Unlocked Games"),
            tileNpagewidget("Log Out", onTap: () {
              try {
                AuthService auth = AuthService();
                auth.firebaseAuth.signOut();
                removeAllAndPush(context, const LogInScreen());
              } catch (e) {
                showToast(e.toString());
              }
            }),
            basicSpace(height: 100)
          ],
        ),
      ),
    );
  }
}

Widget tileWidget(String title, {String? subtitle, IconData? icon}) => ListTile(
      title: myText(title,
          style: theme.subtitle02, padding: 0, align: TextAlign.start),
      subtitle: icon == null
          ? myText(subtitle!,
              style: theme.subtitle01!.copyWith(color: theme.colors03),
              padding: 0,
              align: TextAlign.end)
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                basicIcon(icon, color: theme.colors03),
                myText(
                  subtitle ?? "",
                  style: theme.subtitle01!.copyWith(color: theme.colors03),
                  padding: 0,
                )
              ],
            ),
    );
Widget tileNpagewidget(String title, {VoidCallback? onTap}) => ListTile(
      dense: true,
      onTap: onTap,
      title: myText(title,
          style: theme.subtitle02, padding: 0, align: TextAlign.start),
      trailing: basicIcon(FontAwesomeIcons.caretRight, color: theme.colors01),
    );
