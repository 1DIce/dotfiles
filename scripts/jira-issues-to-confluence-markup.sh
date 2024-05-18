#!/usr/bin/env bash

awk -F',' '
NR==1 {
    for (i=1; i<=NF; i++) {
        ix[$i] = i
    }
}
NR>1 {
print "* " "{jira:key="$ix["Issue key"]"}"
}
'

