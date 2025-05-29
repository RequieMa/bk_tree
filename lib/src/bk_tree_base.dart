import "dart:core";
import "package:meta/meta.dart";
import "bk_tree_node.dart";
import "utils/logger.dart";

/// Logger instance for BK-Tree operations
final loggerBKTree = returnLogger("BKTree");

/// Represents a candidate node during tree searches
///
/// Contains:
/// - `candList`: List of candidate node names
/// - `validFlag`: Whether current node meets distance criteria
/// - `distance`: Calculated distance from query
typedef Candidate = ({
  List<String> candList,
  bool validFlag,
  int distance,
});

/// A Burkhard-Keller Tree implementation
/// for efficient nearest neighbor searches
/// using configurable distance metrics,
/// optimized for large-scale similarity comparisons.
class BKTree {
  final Map<String, String> _hashMap;
  final int Function(String, String) _distanceFunction;
  final String _rootKey;
  final Map<String, BKTreeNode> _nodes = {};
  late final List<String> _candidates;
  final bool _verbose;

  /// Creates a BK-Tree from a map of key-value pairs
  ///
  /// - [hashMap]: Map of identifiers to hash values
  /// - [distanceFunction]: Function to calculate distance between two hashes
  /// - [verbose]: Enable debug logging
  BKTree(
    Map<String, String> hashMap,
    int Function(String, String) distanceFunction, {
    bool verbose = true,
  })  : _hashMap = hashMap,
        _distanceFunction = distanceFunction,
        _rootKey = hashMap.keys.first,
        _verbose = verbose {
    final remainingKeys = hashMap.keys.skip(1).toList();
    _nodes[_rootKey] = BKTreeNode(
      nodeName: _rootKey,
      nodeValue: _hashMap[_rootKey]!,
    );
    _candidates = [_nodes[_rootKey]!.nodeName];
    constructTree(remainingKeys);
  }

  /// Constructs the tree structure from remaining keys
  void constructTree(List<String> keys) {
    if (_verbose) loggerBKTree.info("Start: Construct the BK-Tree");
    for (final key in keys) {
      loggerBKTree.info("constructTree: $key, $_rootKey");
      _insertNode(key, _rootKey);
    }
    if (_verbose) {
      loggerBKTree.info(keys);
      loggerBKTree.info("End: Construct the BK-Tree");
    }
  }

  /// Performs a nearest neighbor search within tolerance
  ///
  /// Returns list of matches with their distances
  List<dynamic> search({
    required String queryHash,
    int tolerance = 5,
  }) {
    final validRetrievals = [];
    final candidates = List<String>.from(_candidates);

    while (candidates.isNotEmpty) {
      final candidateName = candidates.removeLast();
      final currentNode = _nodes[candidateName]!;
      final (:candList, :validFlag, :distance) = _getNextCandidates(
        queryHash: queryHash,
        candidateObj: currentNode,
        tolerance: tolerance,
      );

      if (validFlag) {
        validRetrievals.add(
          {candidateName: distance.toInt()},
        );
      }
      candidates.addAll(candList);
    }
    return validRetrievals;
  }

  Candidate _getNextCandidates({
    required String queryHash,
    required BKTreeNode candidateObj,
    required int tolerance,
  }) {
    final distance = _distanceFunction(candidateObj.nodeValue, queryHash);
    final validity = distance <= tolerance;
    final searchRangeDistance = {
      for (var i = distance - tolerance; i < distance + tolerance + 1; ++i) i,
    };
    final candidateChildren = candidateObj.children;
    final candidates = candidateChildren.keys
        .where((key) => searchRangeDistance.contains(candidateChildren[key]))
        .toList();
    return (
      candList: candidates,
      validFlag: validity,
      distance: distance,
    );
  }

  /// Inserts a new node into the tree structure
  void _insertNode(String newNodeKey, String currentKey) {
    var newNodeHash = _hashMap[newNodeKey]!;
    var currentNode = _nodes[currentKey]!;
    int? nullableDistance;
    try {
      final tmpDistance = _distanceFunction(newNodeHash, currentNode.nodeValue);
      nullableDistance = tmpDistance;
    } on Exception catch (e) {
      loggerBKTree.info("_distanceFunction Error: $e, $currentKey");
    } 

    if (nullableDistance != null) {
      var currentDistance = nullableDistance;
      while (true) {
        final existingChildKey = currentNode.children.keys.firstWhere(
          (key) => currentNode.children[key] == currentDistance,
          orElse: () => "",
        );
        if (existingChildKey.isEmpty) {
          _nodes[currentKey]!.children[newNodeKey] = currentDistance;
          _nodes[newNodeKey] = BKTreeNode(
            nodeName: newNodeKey,
            nodeValue: newNodeHash,
            parentName: currentKey,
          );
          break;
        }

        currentKey = existingChildKey;
        currentNode = _nodes[currentKey]!;
        currentDistance = _distanceFunction(
          newNodeHash,
          currentNode.nodeValue,
        );
      }
    }
  }

  /// Root node key for testing purposes
  @visibleForTesting
  String get rootKey => _rootKey;

  /// Internal node structure for testing validation
  @visibleForTesting
  Map<String, BKTreeNode> get nodeMap => _nodes;
}
