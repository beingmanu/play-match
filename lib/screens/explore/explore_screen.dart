import 'package:flutter/material.dart';

import '../../models/communitie_post.dart';
import '../../services/api_service.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/feed_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<CommunitiePost>> _futurecommunities;
  ApiService apiService = ApiService();

  @override
  void initState() {
    _futurecommunities = apiService.getAllCommunitiesPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScafold(
      title: "explore",
      body: FutureBuilder(
          future: _futurecommunities,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: circleLoader(),
              );
            }
            if (snap.data == null) {
              return Center(
                child: myText("No Data!"),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                    snap.data!.length,
                    (index) => FeedWidget(
                      postData: snap.data![index],
                    ),
                  ),
                  basicSpace(height: 100)
                ],
              ),
            );
          }),
    );
  }
}
