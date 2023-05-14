import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  Logger get log => Logger(T.toString());

  @override
  void initState() {
    log.info("$T initState");
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    log.info("$T dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
