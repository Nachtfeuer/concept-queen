# concept-queen
    
[![Build Status](https://travis-ci.org/Nachtfeuer/concept-queen.svg?branch=master)](https://travis-ci.org/Nachtfeuer/concept-queen)

### Table Of Content
[**Introduction**](#introduction)  
[**Who wins?**](#who-wins)  
[**The performance report**](#the-performance-report)  
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
[**Running with Dart**](#running-with-dart)  
[**Running with julia**](#running-with-julia)  

## Introduction
The queen algorithm in different languages. The algorithm is about a `n x n`
chessboard to place `n` queens that way that no queen does threaten another
one. On a 8x8 chessboard you will find 92 solutions. When the size of the
board does increase then the number of solution grow significantly.

I'm mainly a developer for C/C++, Java and Python and I were interested
in how easy or how difficult it is to implement the algorithm in other languages.
Also I am interested to compare the performance.

For now this project covers Python, Perl, Ruby, PHP, C, C++, Java,
Nodejs, FreeBasic, FreePascal, D, CSharp (Mono), Scala, Groovy, Go, Kotlin, Lua,
Dart and julia.

## Who wins?
That's not 100% clear; of course I've the measurements and from this
C++ and C wins and also Go and D are not bad. However my domain languages
are C++, Java and Python. As an exception In Python I did the most optimal
implementation of the algorithm and at least with PyPy I were able to be faster
as some other languages but still far away from the ones in the top four.
I'm not expert in all those languages and I might not have choosen the optimal
implementation; that's why the current results are not yet final.

Also to say that most algorithms are single threaded only and if I implement it
in multithreaded some of the languages might be able to climb the ranking since
some of those languages are designed for that purpose. I did for Python; other
languages might follow if I have time ...

## The performance report
You have to clone this repository; stay at root of the repository
and then use Python which is usally available:

```
# Python < 3
# python -m SimpleHTTPServer

# python >= 3
# python -m http.server
```
You then can open the report at http://localhost:8000/reports/report.html.

## Rules
Everybody is - of course - invited to participate. You can use any language
or an already provided language with an improved algorithm. However these
are the rules

 - your contributed content has same license as the project (MIT)
 - your algorithm should be able to accept an integer `n` representing a `n x n` chessboard
 - also - by default - you do not print all solutions of your application but you collect all.
   Memory consumption is relevant.
 - The concrete language has to run isolated inside a Docker container;
   there are enough examples in folder `scripts`.
 - Keep it short and simple.
 - Looking at the times as measured while running through Travis CI you should
   care for that you do not choose a chessboard dimension for which
   the calculation takes significantly longer than 2 minutes.
 - You provide the calculation for each chessboard dimension starting by 8
   until the last one that does fit to the time limitation. A few seconds more
   is not bad but more than 2 minutes will be highlighted red in the report.
 - The output format for each chessboard should be like the example shows. You can run the `analyse.py` scripts to see whether an assertion is thrown.
 - You extend the analyse.json when you provide a new language.
 - You extend the README.md (this file) for the new language.
 - Try to provide the setup for CentOS7. I have not done it for Dart but for all others.
 
### Example for expected format
```
Queen raster (11x11)
...took 0.353048 seconds.
...2680 solutions found.
```

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

When running like this:
```
SOURCE=Queen_openmp.cxx scripts/run_gcc5.sh
```
You can cheeck then `reports/Queen_openmp.cxx.log` for the results.
It does use [http://www.openmp.org/](http://www.openmp.org/)
running the queen algorithm significant faster using all available cpu's.

## Running with Nodejs 

Homepage is: https://nodejs.org/en/
I know that 16x16 does exceed the limit a bit but
it will be highlighted in red anyway. Intresting
to know is that before Node.js did crash because
of memory limitation. There's an option where you
can specify/increase this limit (see script).

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
Also have a read here:
http://docs.scala-lang.org/overviews/collections/performance-characteristics.html

I missed the `continue` statement.

```
scripts/run_scala.sh
```

You can check then `reports/Queen.scala.log`
for the results.

## Running with Groovy

Homepage is: http://groovy-lang.org/index.html

In the newest version is also the option to use
the compile static annotation but this would force
you to give up the simple code.

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

Homepage is: https://www.lua.org/ and http://luajit.org/.

I have been a bit displeased with this language.
The dump of what is called a table structure 
seems not provided by simply calling print like
you can do in Python (as an example). Also it seems
that this language constantly changes its interfaces.
Copying a table can be done in one release with `table.unpack`
while not in another. In one release you can do `table.nget`
while you have to do in another `#table` to get the number
of elements. Also the index seems often 1 based instead of
zero based which I think is weired since a lot of languages
are using zero based. Finally the missing `continue` statement
forced me to do ugly indentation of the logic. When any
Lua developer would like to give good advises on how to
do those things easier/better ... be welcome.

```
scripts/run_lua.sh
scripts/run_luajit.sh
```

You can check then `reports/Queen.lua.log` and `reports/Queen.luajit.log`
for the results.

## Running with Dart

Homepage is: https://www.dartlang.org/

I feel quite comfortable using the Dart language.
At all parts of the algorithm where I've experienced
difficulties in other languages I were able to 
implement it easily in Dart. Installation on Windows
as well as Debian was easy too. The only negative
I found is that there is no CentOS based distribution.
I tried to compile and link myself but it simply 
takes too long.

```
scripts/run_dart.sh
```

You can check then `reports/Queen.dart.log`
for the results.

## Running with julia

Homepage is: http://julialang.org/


```
scripts/run_julia.sh
```

You can check then `reports/Queen.jl.log`
for the results.
