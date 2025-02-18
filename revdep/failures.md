# wru

<details>

* Version: 3.0.3
* GitHub: https://github.com/kosukeimai/wru
* Source code: https://github.com/cran/wru
* Date/Publication: 2024-05-24 18:00:02 UTC
* Number of recursive dependencies: 95

Run `revdepcheck::revdep_details(, "wru")` for more info

</details>

## In both

*   checking whether package ‘wru’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/cmccartan/Documents/Code/R/PL94171/revdep/checks.noindex/wru/new/wru.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘wru’ ...
** package ‘wru’ successfully unpacked and MD5 sums checked
** using staged installation
** libs
using C++ compiler: ‘Apple clang version 16.0.0 (clang-1600.0.26.6)’
using C++17
using SDK: ‘MacOSX15.2.sdk’
clang++ -arch arm64 -std=gnu++17 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG -DARMA_64BIT_WORD=1 -D_REENTRANT -I'/Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/Rcpp/include' -I'/Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/RcppArmadillo/include' -I/opt/homebrew/lib/ -I/opt/homebrew/include -I/opt/homebrew/opt/sqlite/include -I/opt/homebrew/opt/libxml2/include -I/opt/homebrew/opt/proj/include   -O3 -Wno-unknown-pragmas -fPIC  -O3 -march=native -Wno-unused-variable -Wno-unused-function  -c RcppExports.cpp -o RcppExports.o
In file included from RcppExports.cpp:4:
In file included from /Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/RcppArmadillo/include/RcppArmadillo.h:29:
...
In file included from /Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/RcppArmadillo/include/RcppArmadillo/interface/RcppArmadilloForward.h:25:
In file included from /Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/Rcpp/include/RcppCommon.h:30:
In file included from /Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/Rcpp/include/Rcpp/r/headers.h:66:
/Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/Rcpp/include/Rcpp/platform/compiler.h:100:10: fatal error: 'cmath' file not found
  100 | #include <cmath>
      |          ^~~~~~~
1 error generated.
make: *** [RcppExports.o] Error 1
ERROR: compilation failed for package ‘wru’
* removing ‘/Users/cmccartan/Documents/Code/R/PL94171/revdep/checks.noindex/wru/new/wru.Rcheck/wru’


```
### CRAN

```
* installing *source* package ‘wru’ ...
** package ‘wru’ successfully unpacked and MD5 sums checked
** using staged installation
** libs
using C++ compiler: ‘Apple clang version 16.0.0 (clang-1600.0.26.6)’
using C++17
using SDK: ‘MacOSX15.2.sdk’
clang++ -arch arm64 -std=gnu++17 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG -DARMA_64BIT_WORD=1 -D_REENTRANT -I'/Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/Rcpp/include' -I'/Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/RcppArmadillo/include' -I/opt/homebrew/lib/ -I/opt/homebrew/include -I/opt/homebrew/opt/sqlite/include -I/opt/homebrew/opt/libxml2/include -I/opt/homebrew/opt/proj/include   -O3 -Wno-unknown-pragmas -fPIC  -O3 -march=native -Wno-unused-variable -Wno-unused-function  -c RcppExports.cpp -o RcppExports.o
In file included from RcppExports.cpp:4:
In file included from /Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/RcppArmadillo/include/RcppArmadillo.h:29:
...
In file included from /Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/RcppArmadillo/include/RcppArmadillo/interface/RcppArmadilloForward.h:25:
In file included from /Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/Rcpp/include/RcppCommon.h:30:
In file included from /Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/Rcpp/include/Rcpp/r/headers.h:66:
/Users/cmccartan/Documents/Code/R/PL94171/revdep/library.noindex/wru/Rcpp/include/Rcpp/platform/compiler.h:100:10: fatal error: 'cmath' file not found
  100 | #include <cmath>
      |          ^~~~~~~
1 error generated.
make: *** [RcppExports.o] Error 1
ERROR: compilation failed for package ‘wru’
* removing ‘/Users/cmccartan/Documents/Code/R/PL94171/revdep/checks.noindex/wru/old/wru.Rcheck/wru’


```
