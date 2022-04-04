import 'dart:io' show Directory, Process;

import 'node.dart';
import 'local_pkg_reader.dart';

Future<void> build() async {
  var packageRoot = Directory.current.path;
  var root = LocalPkgReader(packageRoot).loadSpec();
  deepSearch(root);
}

Future<void> deepSearch(DependNode root) async {
  if (root.children.isNotEmpty) {
    for (var child in root.children) {
      await deepSearch(child);
    }
  }
  print('${DateTime.now()} start pub get -------> ${root.path}');
  await pubGet(root);
}

Future<void> pubGet(DependNode node) async {
  var dir = Directory(node.path);
  if (!dir.existsSync()) return;
  var res = await Process.run('flutter', ['pub', 'get', (node.path)]);
  if (null != res.stdout) print(res.stdout);
  if (null != res.stderr) print(res.stderr);
}
