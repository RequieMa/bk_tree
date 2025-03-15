import "package:bk_tree/bk_tree.dart";
import "package:test/test.dart";

int hammingDistance(String a, String b) {
  final hash1Bin = BigInt.parse(
    a,
    radix: 16,
  ).toRadixString(2).padLeft(64, "0");
  final hash2Bin = BigInt.parse(
    b,
    radix: 16,
  ).toRadixString(2).padLeft(64, "0");
  final bigInt1 = BigInt.parse(hash1Bin, radix: 2);
  final bigInt2 = BigInt.parse(hash2Bin, radix: 2);

  final xorResult = bigInt1 ^ bigInt2;
  return xorResult.toRadixString(2).replaceAll("0", "").length;
}

void main() {
  group("BK-Tree Node Tests", () {
    test("Correct initialization", () {
      final node = BKTreeNode(
        nodeName: "test_node",
        nodeValue: "1aef",
        parentName: null,
      );
      expect(node.nodeName, equals("test_node"));
      expect(node.nodeValue, equals("1aef"));
      expect(node.parentName, equals(null));
      expect(node.children.isEmpty, isTrue);
    });
  });

  group("BK-Tree Tests", () {
    final hashDict = {
      "a": "9",
      "b": "D",
      "c": "A",
      "d": "F",
      "e": "2",
      "f": "6",
      "g": "7",
      "h": "E",
    };
    final distFunc = hammingDistance;

    test("Insert Tree", () {
      final tempDict = {"a": "9", "b": "D"};
      final bk = BKTree(tempDict, distFunc);
      expect(bk.rootKey, equals("a"));
      expect(bk.nodeMap["a"]!.children.keys.toList(), contains("b"));
      expect(bk.nodeMap["b"]!.parentName, equals("a"));
    });

    test("Insert Tree Collision", () {
      final tempDict = {"a": "9", "b": "D", "c": "8"};
      final bk = BKTree(tempDict, distFunc);
      expect(bk.rootKey, equals("a"));
      expect(bk.nodeMap[bk.rootKey]!.children.length, equals(1));
      expect(bk.nodeMap["b"]!.children.keys.toList(), contains("c"));
    });

    test("Insert Tree Different Nodes", () {
      final tempDict = {"a": "9", "b": "D", "c": "F"};
      final bk = BKTree(tempDict, distFunc);
      expect(bk.rootKey, equals("a"));
      expect(bk.nodeMap[bk.rootKey]!.children.length, equals(2));
      expect(
        bk.nodeMap[bk.rootKey]!.children.keys.toSet().containsAll({
          "b",
          "c",
        }),
        isTrue,
      );
    });

    test("Insert Tree Check Distance", () {
      final tempDict = {"a": "9", "b": "D", "c": "F"};
      final bk = BKTree(tempDict, distFunc);
      expect(bk.rootKey, equals("a"));
      expect(bk.nodeMap[bk.rootKey]!.children["b"], equals(1));
      expect(bk.nodeMap[bk.rootKey]!.children["c"], equals(2));
    });

    test("Construct Tree", () {
      final bk = BKTree(hashDict, distFunc);
      expect(bk.rootKey, equals("a"));
      final leafNodes =
          bk.nodeMap.keys.where((k) => bk.nodeMap[k]!.children.isEmpty).toSet();
      const expectedLeafNodes = {"b", "d", "f", "h"};
      expect(leafNodes, equals(expectedLeafNodes));
      expect(bk.nodeMap[bk.rootKey]!.children.length, equals(4));
      expect(bk.nodeMap["c"]!.children["d"], equals(2));
    });
  });
}
