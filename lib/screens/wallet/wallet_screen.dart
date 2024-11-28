import 'package:flutter/material.dart';

import '../../main.dart';
import '../../widgets/basic_container.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return BasicScafold(
      title: "Wallet",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BasicFilledContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  basicSpace(height: 100),
                  showHDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [myText("\$ 600", padding: 2)],
                  )
                ],
              ),
            ),
            basicSpace(height: 20),
            myText("History", align: TextAlign.start),
            showHDivider(),
            ...List.generate(
              10,
              (index) => ListTile(
                title: myText("+- \$30",
                    style: theme.subtitle02,
                    padding: 0,
                    align: TextAlign.start),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    myText(
                      "Recived from...",
                      style: theme.subtitle02,
                      padding: 0,
                    ),
                    myText(
                      "20 min ago",
                      style: theme.subtitle02,
                      padding: 0,
                    ),
                  ],
                ),
              ),
            ),
            basicSpace(height: 100)
          ],
        ),
      ),
    );
  }
}
