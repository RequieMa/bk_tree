## 0.1.2

* `_insertNode` allows to skip if distance is not well-defined

## 0.1.1

* Infrastructure
  - Configured GitHub Actions workflow
  - Added BSD-3-Clause license verification
  - Integrated lints package for code analysis

## 0.1.0

* Initial implementation of BK-Tree data structure with:
  - Node-based tree construction (`BKTreeNode`)
  - Configurable distance metric support
  - Nearest neighbor search with tolerance
  - Bulk insertion of hash values
  - Verbose logging capabilities
* Core features:
  - Efficient Hamming distance comparisons
  - Parent-child node relationships
  - Testable internal structure exposure
  - Thread-safe candidate management