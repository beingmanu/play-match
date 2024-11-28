import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import '../../utils/navigator_helper.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/main_button.dart';
import '../home/home_dashboard.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    [
      Permission.bluetoothConnect,
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScafold(
      bottomBar: [
        myText(
            "No cap, this app is way more fun with these permissions! Let's unlock all the features.",
            style: theme.subtitle02),
        MainButton(
          isLoading: isLoading,
          title: "All set",
          onTap: () => navigateTo(context, const HomeDashboard()),
        )
      ],
      body: Center(
        child: SvgPicture.asset("assets/permission.svg"),
      ),
    );
  }
}
