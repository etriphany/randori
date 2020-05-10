#!/usr/bin/env bash

# Extended from BashUnit:
# https://github.com/djui/bashunit
#

source $(dirname 0)/assert.bash

########################################################################
# UTILS
########################################################################

# Random number.
#
# $1: Max value
rnd() {
    local result=$(( ( RANDOM % $1 )  + 1 ))
    echo $result
}

# Skip assert.
#
skip() {
    _skipped
}

########################################################################
# OUTCOME
########################################################################

_failed() {
    asserts_failed=$((asserts_failed+1))

    local line=${BASH_LINENO[1]}
    local src="eval sed -ne \"$line p\" ${BASH_SOURCE[2]}"
    local assert=($($src))

    if [ $verbose -ge 2 ] ; then
        if [ $lineshow -eq 1 ]; then
            failed_line="$($src)"
        else
            failed_line=
        fi
        echo -e "\033[31;1m ✘ \033[0m$assert:$line\033[90;1m${failed_line}\033[0m"
    fi
    if [ $verbose -eq 3 ] ; then
        echo -e "\033[31m   Expected\033[0m: $(sed '2,$ s/^/          /g' <<<$2)"
        echo -e "\033[31m   Provided\033[0m: $(sed '2,$ s/^/          /g' <<<$1)"
    fi
}

_passed() {
    asserts_passed=$((asserts_passed+1))

    local line=${BASH_LINENO[1]}
    local src="eval sed -ne \"$line p\" ${BASH_SOURCE[2]}"
    local assert=($($src))
    if [ $verbose -ge 2 ] ; then
        if [ $lineshow -eq 1 ]; then
            success_line="$($src)"
        else
            success_line=
        fi
        printf "\033[32;1m ✔ \033[0m$assert:$line\033[90;1m${success_line}%-30s$eol\033[0m"
    fi
}

_skipped() {
    asserts_skipped=$((asserts_skipped+1))

    local line=${BASH_LINENO[1]}
    local src="eval sed -ne \"$line s/skip //; $line p\" ${BASH_SOURCE[2]}"
    local assert=($($src))
    if [ $verbose -ge 2 ] ; then
        if [ $lineshow -eq 1 ]; then
            skipped_line="$($src)"
        else
            skipped_line=
        fi
        printf "\033[33;1m - \033[0m$assert:$line\033[90;1m${skipped_line}%-30s$eol\033[0m"
    fi
}

########################################################################
# RUN
########################################################################
verbose=2
lineshow=0
eol="\n"

usage() {
    echo "Usage: <testscript> [options...]"
    echo
    echo "Options:"
    echo "  -v, --verbose   Print expected and provided values"
    echo "  -s, --summary   Only print summary omitting individual test results"
    echo "  -q, --quiet     Do not print anything to standard output"
    echo "  -l, --lineshow  Show failing or skipped line after line number"
    echo "  -f, --failed    Print only individual failed test results"
    echo "  -h, --help      Show usage screen"
}

run() {
    # Find and declare 'test_' functions
    local test_pattern="test[a-zA-Z0-9_]\+"
    local tests=$(declare -F | \
        sed -ne '/'"$test_pattern"'$/ { s/declare -f // ; p }')

    # No tests found
    if [ ! "${tests[*]}" ] ; then
        usage
        exit 0
    fi

    # Setup
    if [ "$(LC_ALL=C type -t setup)" = function ]; then setup; fi

    # Run tests
    for test in $tests ;
    do
        if [ $verbose -ge 1 ] ; then
            echo -e "\033[37;1m$test\033[0m"
        fi
        $test
    done

    # Teardown
    if [ "$(LC_ALL=C type -t teardown)" = function ]; then teardown; fi

    # Report
    if [ $verbose -gt 1 ] ; then
        printf "\033[K"
    fi
    if [ $verbose -ge 1 ] ; then
        echo "Done. $asserts_passed passed." \
             "$asserts_failed failed." \
             "$asserts_skipped skipped."
    fi
    exit $asserts_failed
}

# Arguments
while [ $# -gt 0 ]; do
    arg=$1; shift
    case $arg in
        "-v"|"--verbose") verbose=3;;
        "-s"|"--summary") verbose=1;;
        "-q"|"--quiet")   verbose=0;;
        "-l"|"--lineshow") lineshow=1;;
        "-f"|"--failed")   eol="\r";;
        "-h"|"--help")    usage; exit 0;;
        *) shift;;
    esac
done

run
