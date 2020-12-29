#!/bin/bash

TUTORIAL_NAME=TUTORIAL_9

# the order is important!
TO_COMPILE=("async callback_py_impl async_py_impl")

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $DIR/../scripts_util/make_all.sh "$TUTORIAL_NAME" "$TO_COMPILE"