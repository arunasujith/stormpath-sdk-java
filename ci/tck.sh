#! /bin/bash
#
# Copyright 2016 Stormpath, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

OPTION=${1:-NO_OPTION}
OPTION_ARGUMENT01=${2:-NOT_SET}
OPTION_ARGUMENT02=${3:-NOT_SET}

AVAILABLE_PROFILES="java, laravel, express"

WORKDIR=$PWD

RED="\e[31m"
GREEN="\e[32m"
NORMAL="\e[0m"

function error() {
  echo -e "$RED-------> $1 $NORMAL"
}

if [ "$OPTION" = "NO_OPTION" ] ; then
    echo "usage: tck [<option>]"
    echo "Option"
    echo "    clone <dir>            clones stormpath-framework-tck locally under directory <dir>."
    echo "                           If no <dir>, then current dir."
    echo "    run <profile> <dir>    runs actual TCK tests using profile <profile>. Valid profiles are $AVAILABLE_PROFILES."
    echo "                           TCK code will be sought under <dir>. If no directory is specified then current dir will be used."
    echo ""
    exit
fi

case "$OPTION" in
    clone)
        DIR=${OPTION_ARGUMENT01}
        if [ "${DIR}" = "NOT_SET" ] ; then DIR="stormpath-framework-tck"; fi
        echo "-------> Checking out TCK"
        git config user.email "evangelists@stormpath.com"
        git config user.name "stormpath-sdk-java TCK"
        git clone git@github.com:stormpath/stormpath-framework-tck.git ${DIR}
        cd ${DIR}
        git checkout master
        git pull
        echo "-------> TCK cloned"
        ;;
    run)
        PROFILE=${OPTION_ARGUMENT01}
        DIR=${OPTION_ARGUMENT02}
        if [ "${DIR}" = "NOT_SET" ] ; then DIR="stormpath-framework-tck"; fi
        echo "-------> Setting TCK properties"
        echo "-------> Using profile: ${PROFILE}"
        cd ${IR}
        echo "-------> Running TCK now!"
        mvn -P$PROFILE clean verify &> $WORKDIR/target/tck.log
        EXIT_STATUS="$?"
        if [ "$EXIT_STATUS" -ne 0 ]; then
            error "-------> TCK found errors! :^(. Exit status was $EXIT_STATUS"
            cat $WORKDIR/target/tck.log
            exit $EXIT_STATUS
        fi
        echo "-------> TCK ran successfully, no errors found!"
        ;;
esac
