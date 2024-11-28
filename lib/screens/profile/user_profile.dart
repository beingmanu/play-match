import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../utils/navigator_helper.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../wallet/wallet_screen.dart';
import 'account_setting.dart';
import 'widgets/profile_image_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late UserDetails user;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserProvider>(context).userInformation;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      title: "Profile",
      action: [
        GestureDetector(
          onTap: () => navigateTo(context, const WalletScreen()),
          child: basicIcon(FontAwesomeIcons.wallet, size: 20),
        ),
        GestureDetector(
          onTap: () => navigateTo(context, const AccountSettingsScreen()),
          child:
              basicIcon(FontAwesomeIcons.gear, color: theme.colors07, size: 20),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            basicSpace(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ProfileImageWidget(),
                  Spacer(),
                ],
              ),
            ),
            basicSpace(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    myText(user.fullName ?? "",
                        style: theme.title01, padding: 0),
                    basicIcon(FontAwesomeIcons.mars, color: theme.colors04),
                    myText(" 18+", style: theme.subtitle01, padding: 0)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    myText("@${user.userName}",
                        style: theme.headLine02, padding: 0),
                    Row(
                      children: [
                        basicIcon(FontAwesomeIcons.heart,
                            color: theme.colors05),
                        myText("@Partner", style: theme.headLine02, padding: 0)
                      ],
                    ),
                  ],
                )
              ],
            ),
            if (user.location != null)
              Row(
                children: [
                  basicIcon(FontAwesomeIcons.locationPin),
                  myText("Udaipur", style: theme.subtitle01, padding: 0)
                ],
              ),
            Row(
              children: [
                basicIcon(FontAwesomeIcons.instagram, color: theme.colors05),
                myText("beingmanu", style: theme.subtitle01, padding: 0)
              ],
            ),
            Row(
              children: [
                basicIcon(FontAwesomeIcons.briefcase, color: theme.colors06),
                myText("Engineer", style: theme.subtitle01, padding: 0)
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colors01,
                  ),
                  color: theme.colorBackground,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: theme.colors01, blurRadius: 5)]),
              child: myText(
                  "“${user.bio ?? "Part of me suspects that I'm a loser, and the other part of me thinks I'm God Almighty."}”",
                  style: theme.subtitle01),
            ),
            Container(
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colors04,
                    ),
                    color: theme.colorBackground,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: theme.colors04, blurRadius: 5)
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Center(child: myText("69")),
                                myText("your rank", padding: 0)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Center(child: myText("69")),
                                myText("your Points", padding: 0)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    showHDivider(),
                    myText("your win rate is 56%", style: theme.subtitle02)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
