#!/usr/bin/env bash

# Extended from BashUnit:
# https://github.com/djui/bashunit
#
# Copyright (c) 2012, Uwe Dauernheim <uwe@dauernheim.net>
# All rights reserved.

# State
asserts_passed=0
asserts_failed=0
asserts_skipped=0

# Assert that a given expression evaluates to true.
#
# $1: Expression
assert() {
    if $* ; then _passed ; else _failed "$*" true ; fi
}

# Assert that a given output string is equal to an expected string.
#
# $1: Output
# $2: Expected
assertEqualExp() {
    echo $1 | grep -E "^$2$" > /dev/null
    if [ $? -eq 0 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given output string is not equal to an expected string.
#
# $1: Output
# $2: Expected
assertNotEqualExp() {
    echo $1 | grep -E "^$2$" > /dev/null
    if [ $? -ne 0 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given output string starts with an expected string.
#
# $1: Output
# $2: Expected
assertStartsExp() {
    echo $1 | grep -E "^$2" > /dev/null
    if [ $? -eq 0 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given output string contains an expected string.
#
# $1: Output
# $2: Expected
assertContainsExp() {
    echo $1 | grep -E "*$2*" > /dev/null
    if [ $? -eq 0 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given output string is equal to an expected string.
#
# $1: Output
# $2: Expected
assertEqualStr() {
    if [ $1 == $2 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given output string is not equal to an expected string.
#
# $1: Output
# $2: Expected
assertNotEqualStr() {
    if [ $1 != $2 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that the last command's return code is equal to an expected integer.
#
# $1: Output
# $2: Expected
# $?: Provided
assertReturn() {
    local code=$?
    if [ $code -eq $2 ] ; then _passed ; else _failed "$code" "$2" ; fi
}

# Assert that the last command's return code is not equal to an expected integer.
#
# $1: Output
# $2: Expected
# $?: Provided
assertNotReturn() {
    local code=$?
    if [ $code -ne $2 ] ; then _passed ; else _failed "$code" "$2" ; fi
}

# Assert that a given integer is equal to an expected integer.
#
# $1: Output
# $2: Expected
assertEqual() {
    if [ $1 -eq $2 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given integer is not equal to an expected integer.
#
# $1: Output
# $2: Expected
assertNotEqual() {
    if [ $1 -ne $2 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given integer is greater than an expected integer.
#
# $1: Output
# $2: Expected
assertGreaterThan() {
    if [ $1 -gt $2 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given integer is greater than or equal to an expected integer.
#
# $1: Output
# $2: Expected
assertAtLeast() {
    if [ $1 -ge $2 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given integer is less than an expected integer.
#
# $1: Output
# $2: Expected
assertLessThan() {
    if [ $1 -lt $2 ] ; then _passed ; else _failed "$1" "$2" ; fi
}

# Assert that a given integer is less than or equal to an expected integer.
#
# $1: Output
# $2: Expected
assertAtMost() {
    if [ $1 -le $2 ] ; then _passed ; else _failed "$1" "$2" ; fi
}