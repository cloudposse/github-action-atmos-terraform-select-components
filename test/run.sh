#!/bin/bash

./src/filter.sh

expected_content='[{"stack":"core-ue2-auto","component":"test-2","stack_slug":"core-ue2-auto-test-2","component_path":""},{"stack":"plat-ue2-dev","component":"test-4","stack_slug":"plat-ue2-dev-test-4","component_path":""},{"stack":"plat-ue2-sandbox","component":"test-5","stack_slug":"plat-ue2-sandbox-test-5","component_path":""}]'
file_content=$(<components.json)

cat components.json

if [ "$expected_content" != "$file_content" ]; then
  echo "Test failed"
  exit 1
else 
  echo "Test succeeded"
fi