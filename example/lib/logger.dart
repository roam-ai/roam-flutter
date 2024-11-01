import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CustomLogger {
  static Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await CustomLogger._localPath;
    return File('$path/logs.txt');
  }

  static Future<File> writeLog(String log) async {
    final file = await CustomLogger._localFile;
    print(file.path);
    return file.writeAsString(log + "\n\n\n", flush: true, mode: FileMode.append);
  }
}
