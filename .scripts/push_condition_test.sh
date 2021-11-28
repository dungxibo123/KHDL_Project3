#!/bin/sh
# Set Enviroment $GITHUB_ACCESS_TOKEN
# Which can be get from your account on github
# this script just only work in Unix / Linux
# There is no help for this push command
# Reading the code and find out what it is please, I very lazy to writing a document, and this scripts
# also too simple to writting a document for.
# Good luck with the scripts.
# Thanks,
# dungxibo123
# @author: dungxibo123



function get_current_branch() {
    local branch_name="$(git symbolic-ref -q HEAD)"
    local branch_name=${branch_name#refs/heads/}
    echo $branch_name
    return $branch_name
}

push() {
    if [[ ! -d .git ]]
    then 
        git init
    fi
    local MODIFY_FILE_ONLY=0
    local ALL_FILE=0
    local MESSAGE="This is Default Message when commit by Scripts"
    local REMOTE_URL="https://github.com/"
    local FILE_REGEX=""
    local SET_REMOTE=0
    local BRANCH=$(get_current_branch)
    for arg in "$@"
    do
        case $arg in
            -m|--message)
            MESSAGE="$2"
            shift shift
            ;;
            -u|--modify)
            MODIFY_FILE_ONLY=1
            shift
            ;;
            -b|--branch)
            git checkout -b $2
            BRANCH="$2"
            shift
            shift
            ;;
            -a|--all)
            ALL_FILE=1
            shift
            ;;
            -r|--remote)
               REMOTE_URL="{$REMOTE_URL}/{$2}" 
               echo "This alias will be origin"
            shift
            shift
            ;;
            -f|--file)
            shift

            while [[ ! $1 =~ ^- ]] && [ "$#" -gt 0 ]
            do
                FILE_REGEX="$FILE_REGEX $1"
                git add $1
                #echo "Curernt regex: \{ "$FILE_REGEX" \ }"
                shift
            done
            FILE_REGEX="${FILE_REGEX:1}"
            ;;
        esac
    done
    if [[ "$ALL_FILE" -eq "1" ]]
    then
        echo "ALL FILE Received"
        git add .
    else
        if [[ "$MODIFY_FILE_ONLY" -eq "1" ]]
        then
            echo "Modify only mode"
            git add -u
        else
            if [[ ! "$FILE_REGEX"  ]]
            then
                echo "Error, doesn't have any file to commit" && return;
            else
                continue#echo "FILE REGEX MODE: "$FILE_REGEX"" #git add "$FILE_REGEX"
            fi
        fi
    fi
    if [[ $SET_REMOTE -gt 0 ]] 
    then 
        git remote add origin $REMOTE_URL    
    fi
    git commit -m "$MESSAGE"
    git push -u origin "$BRANCH"

#    echo "Let's see what in MODIFY ONLY ${MODIFY_FILE_ONLY}\n"
#    echo "WHICH ABOUT MESSAGE ? ${MESSAGE}\N"
#    echo "branch: ${BRANCH}\n"

}
