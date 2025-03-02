#!/bin/bash

for file in $(find .. -name "*.go" -not -path "./vendor/*"); do

  if [[ "$file" =~ [A-Z] ]]; then
    echo "Error: $file contains uppercase letters"
    echo "All Go files in the project (excluding vendor directory) must use snake_case"
    exit 1
  fi
done

echo "File names clean"
echo "check complete"
echo "All Go files in the project (excluding vendor directory) use lowercase letters"
exit 0
