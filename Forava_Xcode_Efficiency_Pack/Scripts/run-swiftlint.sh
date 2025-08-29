#!/bin/bash
# Run SwiftLint if installed (brew install swiftlint)
if command -v swiftlint >/dev/null 2>&1; then
  swiftlint --config Quality/.swiftlint.yml
else
  echo "SwiftLint not installed; skipping lint."
fi
