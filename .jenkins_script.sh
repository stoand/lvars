#!/bin/bash

# NOTE: uses env vars JENKINS_GHC and CABAL_FLAGS, if available.
#       Also passes through extra args to the major cabal install command.

set -e
set -x

# Temporarily staying off of 1.20 due to cabal issue #1811:
# CABAL=cabal-1.18.0
# That issue is passed, now requiring a recent version of cabal:
if [ "$CABAL" == "" ]; then 
  CABAL=cabal-1.20
#  CABAL=cabal-1.21
fi

SHOWDETAILS=always
# SHOWDETAILS=streaming

if [ "$JENKINS_GHC" == "" ]; then 
  GHC=ghc
else
  ENVSCRIPT=$HOME/rn_jenkins_scripts/acquire_ghc.sh
  # This is specific to our testing setup at IU:
  if [ -f "$ENVSCRIPT" ]; then 
    source "$ENVSCRIPT"
  fi
  GHC=ghc-$JENKINS_GHC
fi

PKGS=" ./lvish ./par-classes ./par-collections ./par-collections/tests "
# ./par-transformers

cd ./haskell/
TOP=`pwd`
$CABAL sandbox init
$CABAL sandbox hc-pkg list
for path in $PKGS; do 
  cd $TOP/$path
  $CABAL sandbox init --sandbox=$TOP/.cabal-sandbox
done
cd $TOP

CFG=" --force-reinstalls "

if [ "$PROF" == "" ] || [ "$PROF" == "0" ]; then 
  CFG="$CFG --disable-library-profiling --disable-executable-profiling"
else
  CFG="$CFG --enable-library-profiling --enable-executable-profiling"
fi  
CABAL_FLAGS="$CABAL_FLAGS1 $CABAL_FLAGS2 $CABAL_FLAGS3"

# Simpler but not ideal:
# $CABAL install $CFG $CABAL_FLAGS --with-ghc=$GHC $PKGS ./monad-par/monad-par/ --enable-tests --force-reinstalls $*

# # Temporary hack, install containers first or we run into problems with the sandbox:
# # $CABAL install containers --constraint='containers>=0.5.5.1'

# Also install custom version of monad-par:
# In newer cabal (>= 1.20) --enable-tests is separate from --run-tests:
$CABAL install $CFG $CABAL_FLAGS --with-ghc=$GHC $PKGS --enable-tests  $*

# Avoding the atomic-primops related bug on linux / GHC 7.6:
if ! [ `uname` == "Linux" ]; then  
  for path in $PKGS; do 
    echo "Test package in path $path."
    cd $TOP/$path
    # Assume cabal 1.20+:
    cabal test --show-details=$SHOWDETAILS
  done
fi
