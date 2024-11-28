import 'package:flutter/material.dart';

import '../../core/data.dart';
import '../../main.dart';
import '../../utils/navigator_helper.dart';
import '../../widgets/basic_container.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/main_button.dart';
import 'permission_page.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  bool isLoading = false;
  List<String> hobbies = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      title: "Your interests",
      bottomBar: [
        MainButton(
          isLoading: isLoading,
          title: "Next",
          onTap: () {
            navigateTo(context, const PermissionScreen());
          },
        )
      ],
      body: Column(
        children: [
          // myText("Upload your quick smile", style: theme.text20Bold),
          // basicSpace(height: 20),
          // Center(
          //   child: Container(
          //     height: size.width * .4,
          //     width: size.width * .4,
          //     child: CircleAvatar(
          //       backgroundColor: theme.colors05,
          //       radius: 18,
          //       child: basicIcon(FontAwesomeIcons.camera),
          //     ),
          //     alignment: Alignment.bottomRight,
          //     decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: theme.colors04,
          //         border: Border.all(
          //           color: theme.colors05,
          //           width: 2,
          //         ),
          //         image: const DecorationImage(
          //             fit: BoxFit.cover,
          //             image: NetworkImage(
          //                 "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")),
          //         boxShadow: [
          //           BoxShadow(
          //             blurRadius: 10.0,
          //             color: theme.colors05,
          //           )
          //         ]),
          //   ),
          // ),
          // basicSpace(height: 50),

          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              children: [
                ...List.generate(
                  genZHobbies.length,
                  (index) => GestureDetector(
                    onTap: () {
                      if (!hobbies.contains(genZHobbies[index])) {
                        setState(() => hobbies.add(genZHobbies[index]));
                      } else {
                        setState(() => hobbies.remove(genZHobbies[index]));
                      }
                    },
                    child: BasicOutLineContainer(
                      padding: EdgeInsets.zero,
                      marginh: 5,
                      child: myText(genZHobbies[index],
                          style: hobbies.contains(genZHobbies[index])
                              ? theme.subtitle03!
                                  .copyWith(color: theme.colors01)
                              : theme.subtitle02),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
