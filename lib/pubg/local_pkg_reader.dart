import 'dart:collection';
import 'dart:io';

import '../utils/yaml_reader.dart';
import 'node.dart';

const String _pubspec = 'pubspec.yaml';

final HashMap<String, DependNode> _hashMapNodes = HashMap<String, DependNode>();

class LocalPkgReader {
  final String rootPath;

  const LocalPkgReader(this.rootPath);

  DependNode loadSpec([String? path]) {
    var yamlMap = loadYaml(rootPath +
        Uri(path: '${path ?? ''}/').toFilePath(windows: Platform.isWindows) +
        _pubspec);
    var node = DependNode(
      package: yamlMap['name'],
      path: path ?? '',
    )..status = Status.getting;
    _hashMapNodes[node.package] = node;
    var map = yamlMap['dependencies'];
    map.forEach((package, value) {
      if (null == value || value is! Map || null == value['path']) return;
      if (_hashMapNodes[package]?.status == Status.prepare) return;
      if (_hashMapNodes[package]?.status == Status.getting) {
        _hashMapNodes[package]?.status = Status.affiliate;
        return;
      }
      var child = loadSpec('${node.path}/${value['path']}');
      node.children.add(child);
    });
    return node..status = Status.prepare;
  }
}
