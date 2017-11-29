#!/bin/bash
find . -regextype posix-egrep -regex "./.*/$1/.*" | grep "$2"
