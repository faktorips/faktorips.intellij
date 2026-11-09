#!/bin/bash
set -u
gradle_home="${GRADLE_USER_HOME:-$HOME/.gradle}"

./gradlew --stop || true
for attempt in 1 2 3; do
  if rm -rf "${gradle_home:?}"/{caches,daemon,native,workers,.tmp}; then
    echo "Gradle cleanup successful (attempt $attempt): ${gradle_home}"
    exit 0
  fi
  echo "WARNING: gradle cleanup attempt $attempt failed, retrying"
  sleep 5
done
echo "WARNING: gradle cleanup incomplete in ${gradle_home}"
