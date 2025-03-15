/// A node in a BK-Tree data structure for efficient similarity searches.
///
/// Each node contains a [nodeValue] and maintains
/// child nodes [children] with their corresponding
/// distance from this node's value.
class BKTreeNode {
  /// Unique identifier for this node, typically representing the file path
  final String nodeName;

  /// The hash value stored in this node, used for distance comparisons
  final String nodeValue;

  /// Identifier of the parent node in the tree structure (null for root node)
  final String? parentName;

  /// Map of child nodes where keys are child identifiers and values are
  /// the calculated Hamming distances from this node's value
  final Map<String, int> children = {};

  /// Creates a BK-Tree node with the given parameters.
  ///
  /// - [nodeName]: Unique identifier for the node
  /// - [nodeValue]: The value stored in the node (currently 64-bit hash)
  /// - [parentName]: Optional identifier of parent node
  BKTreeNode({
    required this.nodeName,
    required this.nodeValue,
    this.parentName,
  });
}
