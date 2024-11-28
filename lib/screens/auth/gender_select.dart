import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/data.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../utils/navigator_helper.dart';
import '../../widgets/basic_container.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/main_button.dart';
import 'profile_update_screen.dart';

class GenderSelectScreen extends StatefulWidget {
  const GenderSelectScreen({super.key});

  @override
  State<GenderSelectScreen> createState() => _GenderSelectScreenState();
}

class _GenderSelectScreenState extends State<GenderSelectScreen> {
  String gender = "";
  String orientation = "";

  bool isLoading = false;
  late UserDetails userDetails;

  @override
  void didChangeDependencies() {
    userDetails = Provider.of<UserProvider>(context).userInformation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      bottomBar: [
        MainButton(
          isLoading: isLoading,
          title: "Next",
          onTap: () async {
            // final UserServices userServices = UserServices();
            // await userServices.updateUserDetails({}, userDetails.sId!).then(
            //   (value) {
            //     if (value is UserDetails) {
            //       Provider.of(context)
            //     }
            //   },
            // );
            navigateTo(context, ProfileUpdateScreen());
          },
        )
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // myText("Unleash your identity", style: theme.text20Bold),
          // basicSpace(height: 30),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     ...List.generate(
          //       3,
          //       (index) => Column(
          //         children: [
          //           GestureDetector(
          //             onTap: () => setState(
          //                 () => gender = ["Male", "Female", "Trans"][index]),
          //             child: Container(
          //               height: size.width * .2,
          //               width: size.width * .2,
          //               alignment: Alignment.bottomRight,
          //               decoration: BoxDecoration(
          //                   border: Border.all(color: theme.colors01),
          //                   shape: BoxShape.circle,
          //                   boxShadow: [
          //                     BoxShadow(blurRadius: 1, color: theme.colors01)
          //                   ],
          //                   image: DecorationImage(
          //                       fit: BoxFit.cover,
          //                       image: NetworkImage([
          //                         "https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?t=st=1719957476~exp=1719961076~hmac=b0109b5413878427e55eb67534d88ed794a61d7e12e29fa8b8128402ca537a32&w=996",
          //                         "https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?t=st=1719957530~exp=1719961130~hmac=411e162e4e6e01bf877f3cc1a914976a01c5c74cb127f5d72364b735cb5ced06&w=996",
          //                         "https://img.freepik.com/free-photo/transgender-man-wearing-make-up-half-his-face_23-2148784399.jpg?t=st=1719957584~exp=1719961184~hmac=0e8eb1b7ab1cce989f17366729292c5ac70773f615f350d5e79f4f449f9097b1&w=360"
          //                       ][index]))),
          //               child: gender == ["Male", "Female", "Trans"][index]
          //                   ? basicCheckMark()
          //                   : null,
          //             ),
          //           ),
          //           myText(["Male", "Female", "Trans"][index],
          //               style: theme.subtitle01)
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     gender == "Beyond the labels"
          //         ? basicCheckMark()
          //         : Container(
          //             height: 20,
          //             width: 20,
          //             decoration: BoxDecoration(
          //               border: Border.all(color: theme.colors01),
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(blurRadius: 1, color: theme.colors01)
          //               ],
          //             ),
          //           ),
          //     basicSpace(width: 15),
          //     GestureDetector(
          //         onTap: () => setState(() => gender = "Beyond the labels"),
          //         child: myText("Beyond the labels", style: theme.subtitle01)),
          //   ],
          // ),
          basicSpace(height: 30),
          myText("Sexual Orientation", style: theme.text20Bold),
          basicSpace(height: 30),
          Wrap(
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              ...List.generate(
                  sexualOriantetionList.length,
                  (index) => GestureDetector(
                        onTap: () => setState(
                            () => orientation = sexualOriantetionList[index]),
                        child: BasicOutLineContainer(
                          padding: EdgeInsets.zero,
                          marginh: 5,
                          child: myText(sexualOriantetionList[index],
                              style: orientation == sexualOriantetionList[index]
                                  ? theme.subtitle03!
                                      .copyWith(color: theme.colors01)
                                  : theme.subtitle02),
                        ),
                      ))
            ],
          )
        ],
      ),
    );
  }
}

Widget basicCheckMark() => Container(
      height: 20,
      width: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(blurRadius: 1, color: theme.colors01)],
      ),
      padding: const EdgeInsets.all(2),
      child: basicIcon(FontAwesomeIcons.check, size: 15, pad: 0),
    );
