#!/bin/sh

set -e

echo Building code...
rm -f ./terraform/goodbye-fn/function.zip
zip function.zip index.js
mv function.zip ../terraform/goodbye-fn/
echo Finished building!
