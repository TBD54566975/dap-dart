_help:
  @just -l

deps:
  #!/bin/bash
  set -euo pipefail

  dart pub get

test:
  #!/bin/bash
  set -euo pipefail

  dart test

analyze:
  #!/bin/bash
  set -euo pipefail

  dart analyze