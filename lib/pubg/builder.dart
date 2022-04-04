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
  if (root.status == Status.affiliate) return;
  await pubGet(root);
  root.status = Status.finished;
}

Future<void> pubGet(DependNode node) async {
  var res = await Process.run(
      'flutter', ['pub', 'get', (node.path.replaceFirst(RegExp('/'), ''))],
      workingDirectory: Directory.current.path, runInShell: true);
  if (null != res.stdout) print(res.stdout);
  if (null != res.stderr) print(res.stderr);
}
