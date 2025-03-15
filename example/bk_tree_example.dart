import "package:bk_tree/bk_tree.dart";

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
  // Initialize sample hashes (key: filename, value: 64-bit hash)
  final imageHashes = {
    "cat.jpg": "d3b07384d113edec",
    "dog.jpg": "c157a79031e1c40f",
    "cat_copy.jpg": "d3b07384d113edef", // Duplicate
    "landscape.png": "6f4b726212b23f0a",
  };
  print("Input: $imageHashes");

  // Create BK-Tree with Hamming distance
  final tree = BKTree(
    imageHashes,
    hammingDistance,
  );

  // Search for duplicates of cat.jpg
  final results = tree.search(
    queryHash: imageHashes["cat.jpg"]!,
    tolerance: 2, // Allow 2-bit difference
  );

  print("Duplicate findings:");
  for (var match in results) {
    match.forEach((file, distance) {
      print("- Target: cat.jpg. Find match $file (distance: $distance)");
    });
  }
}
