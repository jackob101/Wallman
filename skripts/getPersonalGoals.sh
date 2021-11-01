#! /bin/bash

fileLocation="$HOME/.personalGoals"

awk '{ print NR ". " $0 }' $fileLocation 
