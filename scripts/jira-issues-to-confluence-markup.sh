#!/usr/bin/env bash

awk -F',' '
NR==1 {
    for (i=1; i<=NF; i++) {
        ix[$i] = i
    }
}
NR>1 {
print "* " "{jiraissues:anonymous=false|url=https://jira.cas.de/issues/browse/"$ix["Issue key"]"}"
}
' 

