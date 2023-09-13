#!/usr/bin/env sh
# Convert inc2.csv to inc2-factors.lua and inc2-2.csv to inc2-2-factors.lua for use with fnl2bf.

echo 'return {' > inc2-factors.lua
sed -E 's/^([^,]+,[^,]+),(.+)/\["\1"\]={\2},/g' inc2.csv >> inc2-factors.lua
echo '}' >> inc2-factors.lua

echo 'return {' > inc2-2-factors.lua
sed -E 's/^([^,]+,[^,]+),(.+)/\["\1"\]={\2},/g' inc2-2.csv >> inc2-2-factors.lua
echo '}' >> inc2-2-factors.lua

echo 'return {' > inc2-n-factors.lua
sed -E 's/^([^,]+,[^,]+,[^,]+),(.+)/\["\1"\]={\2},/g' inc2-n.csv >> inc2-n-factors.lua
echo '}' >> inc2-n-factors.lua
