# bk_tree

<!-- [![Pub Version](https://img.shields.io/pub/v/your_package.svg?style=flat)](https://pub.dev/packages/your_package)  -->
[![License](https://img.shields.io/badge/license-BSD--3--Clause-blue?style=flat-square)](LICENSE)

A Dart BK-Tree implementation for efficient nearest neighbor searches using Hamming distance, optimized for bulk file hash processing and duplicate detection.

**Compatibility**: Dart `^3.6.0` 
<!-- | Flutter `^3.16.0` | [Other Requirements] -->

---

## 🚀 Getting Started

<!-- ### Installation
Add to `pubspec.yaml`:
```yaml
dependencies:
  your_package: ^latest_version
```
Then run:
```bash
dart pub get
```

### Basic Usage
```dart
import 'package:your_package/your_package.dart';

void main() {
  final service = ExampleService();
  print(service.getMessage()); // Output: Hello from YourPackage!
}
``` -->

---

## 📦 Features

- **Core Feature 1**: Return a BK-Tree of a folder (using hamming distance)
```dart
final imageHashes = {
  "cat.jpg": "d3b07384d113edec",
  "dog.jpg": "c157a79031e1c40f",
  "cat_copy.jpg": "d3b07384d113edef", // Duplicate
  "landscape.png": "6f4b726212b23f0a",
};

// Create BK-Tree with Hamming distance
final tree = BKTree(
  imageHashes,
  hammingDistance, // Need from another place
);

// Search for duplicates of cat.jpg
final results = tree.search(
  queryHash: imageHashes["cat.jpg"]!,
  tolerance: 2, // Here allow 2-bit difference
);

print("Duplicate findings:");
for (var match in results) {
  match.forEach((file, distance) {
      print("- Target: cat.jpg. Find match $file (distance: $distance)");
  });
}
```

**Output**:
```cmd
- Target: cat.jpg. Find match cat.jpg (distance: 0)
- Target: cat.jpg. Find match cat_copy.jpg (distance: 2)
```

---

## 🧪 Testing

```bash
# Run tests with coverage
dart test
```

## 🤝 Contributing

### Workflow
1. Fork repository
2. Create feature branch:
   ```bash
   git checkout -b feat/your-feature
   ```
3. Follow [Conventional Commits](https://www.conventionalcommits.org):
   ```bash
   git commit -m "feat: add new validation method"
   ```

### Code Style
Follow the **Effective Dart** and `analysis_options.yaml`

---

## 📚 Documentation

<!-- | Resource         | Link                                   |
|------------------|----------------------------------------|
| API Reference    | [View Docs](https://pub.dev/documentation/your_package) |
| Example Project  | [/example](example/)                   |
| Tutorial Series  | [YouTube Playlist](https://youtube.com/your-channel) | -->

---

## 📜 License

BSD 3-Clause "New" or "Revised" License © 2025 RequieMa

Full text at [LICENSE](LICENSE)

---
## 🚧 Maintenance Status
Basic functionalities are done. (Current version is to support author's other packages)

More General Version is under development. 

Please report issues via [GitHub Issues](https://github.com/RequieMa/bk_tree/issues)