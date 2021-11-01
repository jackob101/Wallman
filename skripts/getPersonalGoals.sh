#! /bin/bash

fileLocation="$HOME/.personalGoals"

awk '{ print  " " $0 }' $fileLocation 

