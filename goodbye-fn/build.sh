#!/bin/sh

set -e

version=$1

echo Building code at version ${version}
rm -rf ../terraform/goodbye-fn/function*.zip
zip function-${version}.zip index.js
mv function-${version}.zip ../terraform/goodbye-fn/
echo Finished building!
