import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../games/chess/chess_provider.dart';
import '../provider/user_provider.dart';
import '../provider/video_call_provider.dart';
import 'theme.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(
    create: (_) => UserProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => AppThemeData(),
  ),
  ChangeNotifierProvider(
    create: (_) => VideoCallProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => ChessGameProvider(),
  ),
];
