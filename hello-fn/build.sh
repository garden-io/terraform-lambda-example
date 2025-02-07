#!/bin/sh

set -e

version=$1

echo Building code at version ${version}
rm -rf ../terraform/hello-fn/function*.zip
zip function-${version}.zip index.js
mv function-${version}.zip ../terraform/hello-fn/
echo Finished building!
