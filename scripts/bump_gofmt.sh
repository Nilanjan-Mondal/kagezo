#!/bin/bash

FILES=$(gofmt -l ..)

if [[ -n "$FILES" ]]; then
    echo "starting formatter over:"
    echo "$FILES"
    
    gofmt -w ..
    echo "Files have been formatted."
else
    echo "All files are already formatted."
fi

