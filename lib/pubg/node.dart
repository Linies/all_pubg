/// tree:
///        root                                root
///      ↙                                   ↙
///   use1, [use2, use3](late)  --->      use1, [use3](late)
///   ↙                                   ↙
///  [use2,use4, ...]                  use2, [use4, ...](late)
class DependNode {
  final String package;
  final String path;

  final List<DependNode> children = [];

  Status status = Status.prepare;

  DependNode({required this.package, required this.path});

  bool equals(DependNode other) {
    return super == other || (package == other.package && path == other.path);
  }
}

enum Status {
  finished,
  getting,
  prepare,
  affiliate,
}
