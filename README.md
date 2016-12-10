# concept-queen
    
[![Build Status](https://travis-ci.org/Nachtfeuer/concept-queen.svg?branch=master)](https://travis-ci.org/Nachtfeuer/concept-queen)

### Table Of Content
[**Introduction**](#introduction)  
[**Rules**](#rules)  
[**Running with Python**](#running-with-python)  
[**Running with Perl**](#running-with-perl)  
[**Running with Ruby**](#running-with-ruby)  
[**Running with PHP**](#running-with-php)  
[**Running with C/C++**](#running-with-cc)  
[**Running with Nodejs**](#running-with-nodejs)  
[**Running with Java**](#running-with-java)  
[**Running with FreeBasic**](#running-with-freebasic)  
[**Running with FreePascal**](#running-with-freepascal)  
[**Running with D**](#running-with-d)  
[**Running with Mono**](#running-with-mono)  
[**Running with Scala**](#running-with-scala)  
[**Running with Groovy**](#running-with-groovy)  
[**Running with Go**](#running-with-go)  
[**Running with CLisp**](#running-with-clisp)  
[**Running with Kotlin**](#running-with-kotlin)  
[**Running with Lua**](#running-with-lua)  

## Introduction
The queen algorithm in different languages. The algorithm is about a `n x n`
chessboard to place `n` queens that way that no queen does threaten another
one. On a 8x8 chessboard you will find 92 solutions. When the size of the
board does increase then the number of solution grow significantly.

I'm mainly a developer for C/C++, Java and Python and I were interested
in how easy or how difficult it is to implement the algorithm in other languages.
Also I am interested to compare the performance.

For now this project covers Python, Perl, Ruby, PHP, C, C++, Java,
Nodejs, FreeBasic, FreePascal, D, CSharp (Mono), Scala, Groovy and Go.

Each test runs isolated in a Docker container.


## Rules
Everybody is - of course - invited to participate. You can use any language
or an already provided language with an improved algorithm. However these
are the rules

 - The concrete language has to run isolated inside a Docker container;
   there are enough examples in folder `scripts`.
 - Keep it short and simple.
 - Looking at the times as measured while running through Travis CI you
   care for that you do not choose a chessboard dimension for which
   the calculation takes longer than 2 minutes.
 - You provide the calculation for each chessboard dimension starting by 8
   until the last one that does fit to the time limitation.
 - The output format for each chessboard should be like the example shows. You can run the `analyse.py` scripts to see whether an assertion is thrown.
 
### Example for expected format
```
Queen raster (11x11)
...took 0.353048 seconds.
...2680 solutions found.
```    

!!! More will come later !!!


## Running with Python

Homepage is: https://www.python.org and http://pypy.org/.
The pypy is jit compiler. It's by a significant factor
faster as you can see when using the report.html.

```
scripts/run_python3.5.sh
scripts/run_pypy5.sh
```

You can check then `reports/Queen.py.log`
and `reports/Queen.pypy.log` for the results.

## Running with Perl

```
scripts/run_perl520.sh
```

You can check then `reports/Queen.pl.log`
for the results.

## Running with Ruby

```
scripts/run_ruby23.sh
```

You can check then `reports/Queen.rb.log`
for the results.

## Running with PHP

```
scripts/run_php56.sh
```

You can check then `reports/Queen.php.log`
for the results.

## Running with C/C++
For the setup the devtoolset-4 is used.

```
scripts/run_gcc5.sh
scripts/run_gcc5_c.sh
```

You can check then `reports/Queen.cxx.log` and `reports/Queen.c.log`
for the results.

## Running with Nodejs 

Homepage is: https://nodejs.org/en/

```
scripts/run_nodejs6.sh
```

You can check then `reports/Queen_node.js.log`
for the results.

## Running with Java 

```
scripts/run_java8.sh
```

You can check then `reports/Queen.java.log`
for the results.

## Running with FreeBasic 

Homepage is: http://www.freebasic.net/

```
scripts/run_freebasic.sh
```

You can check then `reports/Queen.bas.log`
for the results.

## Running with FreePascal 

Homepage is: http://www.freepascal.org

```
scripts/run_freepascal.sh
```

You can check then `reports/Queen.pas.log`
for the results.

## Running with D

Homepage is: https://dlang.org/

```
scripts/run_d.sh
```

You can check then `reports/Queen.d.log`
for the results.

## Running with Mono

Homepage is: http://www.mono-project.com/

```
scripts/run_mono.sh
```

You can check then `reports/Queen.cs.log`
for the results.

## Running with Scala

Homepage is: https://www.scala-lang.org/

```
scripts/run_scala.sh
```

You can check then `reports/Queen.scala.log`
for the results.

## Running with Groovy

Homepage is: http://groovy-lang.org/index.html

```
scripts/run_groovy.sh
```

You can check then `reports/Queen.groovy.log`
for the results.


## Running with Go

Homepage is: https://golang.org/

```
scripts/run_go.sh
```

You can check then `reports/Queen.go.log`
for the results.


## Running with CLisp

Homepage is: http://www.sbcl.org/

I've used this compiler because it seems that the GNU clisp doesn't
support classes. In comparison to most other languages the implementation
of the algorithm took me some hours because of the totally different syntax.
A really good source for reading about CLisp is here: http://www.gigamonkeys.com/book/

```
scripts/run_clisp.sh
```

You can check then `reports/Queen.lisp.log`
for the results.

## Running with Kotlin

Homepage is: https://kotlinlang.org

```
scripts/run_kotlin.sh
```

You can check then `reports/Queen.kt.log`
for the results.

## Running with Lua

Homepage is: https://www.lua.org/

```
scripts/run_lua.sh
```

You can check then `reports/Queen.lua.log`
for the results.
