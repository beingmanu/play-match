import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/snackbar.dart';
import '../../widgets/basic_container.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/datetime_widget.dart';
import '../../widgets/main_button.dart';
import 'gender_select.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  bool checkbox = false;

  TextEditingController irlnameC = TextEditingController();
  TextEditingController inboxC = TextEditingController();
  TextEditingController handleC = TextEditingController();
  TextEditingController bdayC = TextEditingController();
  DateTime currentDate = DateTime.now();

  String gender = "";

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget genderButtons(onTap, Size size, IconData icon, String title) {
    return GestureDetector(
      onTap: () => onTap(),
      child: BasicOutLineContainer(
        height: 80,
        width: 70,
        padding: const EdgeInsets.all(5),
        color: gender == title ? theme.buttonColor : theme.colorBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            basicIcon(icon,
                color: gender == title ? Colors.white : theme.textColorDefault,
                pad: 0,
                size: 22),
            myText(
              title,
              style: gender == title
                  ? theme.subtitle02!.copyWith(color: theme.colorWhite)
                  : theme.subtitle02,
              padding: 0,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      title: "Sign Up",
      bottomBar: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: checkbox,
              onChanged: (value) => setState(() => checkbox = !checkbox),
            ),
            myText("I Agree.", style: theme.subtitle01)
          ],
        ),
        myText("Wanna join? Gotta agree to the rules first. (No cap!)",
            style: theme.subtitle01, padding: 0),
        myText("Terms and Conditions", style: theme.subtitle01, padding: 0),
        MainButton(
          isLoading: isLoading,
          title: "Next",
          onTap: () async {
            if (inboxC.text == "" || handleC.text == "" || inboxC.text == "") {
              showToast("Please enter valid details");
              return;
            }
            final auth = AuthService();
            setState(() => isLoading = true);
            await auth
                .userSignUp(
                    irlnameC.text,
                    inboxC.text,
                    auth.firebaseAuth.currentUser!.phoneNumber!.substring(3),
                    handleC.text,
                    currentDate)
                .then((value) {
              if (value is UserDetails) {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(value);
                setState(() => isLoading = false);
                navigateTo(context, const GenderSelectScreen());
              } else {
                setState(() => isLoading = false);
              }
            });
          },
        )
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(
            4,
            (index) => index == 3
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      myText("B-Day",
                          padding: 8,
                          align: TextAlign.start,
                          style: theme.subtitle02),
                      BasicOutLineContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        marginv: 5,
                        child: DateWidget(
                            dateTime: currentDate,
                            onChangedDate: (value) =>
                                setState(() => currentDate = value),
                            firstdate: DateTime(1900),
                            lastdate: DateTime.now()),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      myText(
                          ["Your Name", "Email", "User Handle", "B-Day"][index],
                          padding: 8,
                          align: TextAlign.start,
                          style: theme.subtitle02),
                      BasicOutLineContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        marginv: 5,
                        child: TextField(
                          controller: [irlnameC, inboxC, handleC, bdayC][index],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: [
                              "IRL Name",
                              "Inbox",
                              "@YourHandle",
                              "B-Day"
                            ][index],
                            hintStyle: theme.subtitle03,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          myText("Select your gender",
              padding: 8, align: TextAlign.start, style: theme.subtitle02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              genderButtons(
                  () => setState(() {
                        gender = "Female";
                      }),
                  size,
                  Icons.female_outlined,
                  "Female"),
              genderButtons(
                  () => setState(() {
                        gender = "Male";
                      }),
                  size,
                  Icons.male_outlined,
                  "Male"),
              genderButtons(
                  () => setState(() {
                        gender = "Other";
                      }),
                  size,
                  Icons.transgender_outlined,
                  "Other"),
              genderButtons(
                  () => setState(() {
                        gender = "Decline";
                      }),
                  size,
                  Icons.cancel,
                  "Decline")
            ],
          )
        ],
      ),
    );
  }
}
