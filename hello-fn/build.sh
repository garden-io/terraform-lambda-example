#!/bin/sh

set -e

echo Building code...
rm -f ../terraform/hello-fn/function.zip
zip function.zip index.js
mv function.zip ../terraform/hello-fn/
echo Finished building!
