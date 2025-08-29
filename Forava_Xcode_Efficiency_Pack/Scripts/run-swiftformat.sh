#!/bin/bash
# Run SwiftFormat if installed (brew install swiftformat)
if command -v swiftformat >/dev/null 2>&1; then
  swiftformat --config Quality/.swiftformat ForavaApp ForavaWatch Shared
else
  echo "SwiftFormat not installed; skipping format."
fi
