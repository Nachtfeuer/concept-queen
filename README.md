# concept-queen
    
[![Build Status](https://travis-ci.org/Nachtfeuer/concept-queen.svg?branch=master)](https://travis-ci.org/Nachtfeuer/concept-queen)

### Table Of Content
[**Introduction**](#introduction)  
[**Rules**](#rules)  
[**Running with Python**](#running-with-python)  
[**Running with Perl**](#running-with-perl)  
[**Running with Ruby**](#running-with-ruby)  
[**Running with PHP**](#running-with-php)  
[**Running with C/C++**](#running-with-c)  
[**Running with Nodejs**](#running-with-nodejs)  
[**Running with Java**](#running-with-java)  
[**Running with FreeBasic**](#running-with-freebasic)  
[**Running with FreePascal**](#running-with-freepascal)  
[**Running with D**](#running-with-d)  
[**Running with Mono**](#running-with-mono)  
[**Running with Scala**](#running-with-scala)  
[**Running with Groovy**](#running-with-groovy)  

## Introduction
Queen algorithm in different languages. Since I'm mainly a developer
for C/C++, Java and Python I were interested in how easy or
how difficult it is to implement the algorithm in other languages.
Also I were interested to compare the performance.

Who is the winner? We will see ...


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

!!! More will come later !!!


## Running with Python

Homepage is: https://www.python.org

```
scripts/run_python3.5.sh
```

You can check then `reports/Queen.py.log`
for the results.

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

```
scripts/run_freebasic.sh
```

You can check then `reports/Queen.bas.log`
for the results.

## Running with FreePascal 

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

