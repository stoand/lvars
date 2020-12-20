# LVish library and dependencies

Build: `stack build --flag lvish:-nonidem --file-watch`

[![Hackage page (downloads and API reference)][hackage-lvish]][hackage]


Build Status:

 * Travis: [![Build Status](https://travis-ci.org/iu-parfunc/lvars.svg?branch=master)](https://travis-ci.org/iu-parfunc/lvars)
 * Jenkins: [![Build Status](http://tester-lin.soic.indiana.edu:8080/buildStatus/icon?job=LVish-implementation-2.0)](http://tester-lin.soic.indiana.edu:8080/job/LVish-implementation-2.0/)

This repository is the home of the [LVish](http://hackage.haskell.org/package/lvish) Haskell library for programming with monotonically-growing concurrent data structures, also known as LVars.  More information can be found along with the main library, which is found under [haskell/lvish](haskell/lvish).

<span style="font-size: 0.8em;">(Looking for the data-race detector that accompanied our FHPC '13 paper?  It's [here](https://github.com/lkuper/lvar-race-detector).  Looking for PLT Redex models of LVar calculi?  They're [here](https://github.com/lkuper/lvar-semantics).)</span>


 [hackage-lvish]: http://img.shields.io/hackage/v/lvish.svg
 [hackage]: http://hackage.haskell.org/package/lvish
