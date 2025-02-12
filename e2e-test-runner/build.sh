#!/bin/sh

set -e

version=$1

echo Building code at version ${version}
rm -rf ../terraform/e2e-test-runner/function*.zip
zip function-${version}.zip index.js
mv function-${version}.zip ../terraform/e2e-test-runner/
echo Finished building!
