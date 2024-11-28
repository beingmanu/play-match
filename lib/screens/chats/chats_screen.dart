import 'package:flutter/material.dart';

import '../../main.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      title: "Chats",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...List.generate(
              15,
              (index) => SizedBox(
                width: size.width,
                child: Row(
                  children: [
                    Container(
                      height: size.width * .12,
                      width: size.width * .12,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colors04,
                        border: Border.all(
                          color: theme.colors05,
                          width: 2,
                        ),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            color: theme.colors05,
                          )
                        ],
                      ),
                    ),
                    basicSpace(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          myText("Manish Sapela",
                              padding: 0, align: TextAlign.start),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              myText("hey! please",
                                  style: theme.subtitle01, padding: 0),
                              myText("20 min ago",
                                  style: theme.subtitle01, padding: 0)
                            ],
                          )
                        ],
                      ),
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
