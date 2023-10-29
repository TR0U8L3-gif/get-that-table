import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ReadLineAsync {
  static final stream = stdin
      .asBroadcastStream()
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  static Future<String> readLineAsync() async {
    final completer = Completer<String>();
    late StreamSubscription<String> subscription;
    subscription = stream.listen((line) async {
      await subscription.cancel();
      if (!completer.isCompleted) completer.complete(line);
    });

    return completer.future;
  }
}