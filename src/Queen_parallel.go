//
// @author  Thomas Lehmann
// @file    Queen.go
//
// Copyright (c) 2016 Thomas Lehmann
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies
// or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

type Queen struct {
	width      int
	lastRow    int
	columns    []int
	diagonals1 []int
	diagonals2 []int
	solutions  [][]int
}

// does initialize the queen instance.
func (q *Queen) Init(width int) {
	numberOfDiagonals := 2*width - 1
	q.width = width
	q.lastRow = width - 1
	q.columns = make([]int, width)
	q.diagonals1 = make([]int, numberOfDiagonals)
	q.diagonals2 = make([]int, numberOfDiagonals)

	for i := range q.columns {
		q.columns[i] = -1
	}
}

// Dump prints one solution.
func Dump(solution []int) {
	for x, y := range solution {
		fmt.Printf("[%d, %d]", x+1, y+1)
	}
	fmt.Printf("\n")
}

func (q *Queen) Run(column int) {
	q.columns[column] = 0
	q.diagonals1[column] = 1
	q.diagonals2[q.lastRow+column] = 1
	q.Calculate(1)
}

// Calulate does a recursive search for the solutions
func (q *Queen) Calculate(row int) {
	for column := 0; column < q.width; column++ {
		// is column occupied?
		if q.columns[column] >= 0 {
			continue
		}

		ixDiag1 := row + column
		if q.diagonals1[ixDiag1] > 0 {
			continue
		}

		ixDiag2 := q.lastRow - row + column
		if q.diagonals2[ixDiag2] > 0 {
			continue
		}

		q.columns[column] = row
		q.diagonals1[ixDiag1] = 1
		q.diagonals2[ixDiag2] = 1

		if row == q.lastRow {
			solution := make([]int, q.width)
			copy(solution, q.columns)
			q.solutions = append(q.solutions, solution)
		} else {
			q.Calculate(row + 1)
		}

		q.columns[column] = -1
		q.diagonals1[ixDiag1] = -1
		q.diagonals2[ixDiag2] = -1
	}
}

func main() {
	width := 8

	if len(os.Args) > 1 {
		width, _ = strconv.Atoi(os.Args[1])
	}

	fmt.Printf("Queen raster (%dx%d)\n", width, width)
	queens := make([]Queen, width)

	start := time.Now()
	c := make(chan bool)
	for column := 0; column < width; column++ {
		// run calculation in parallel
		go func(column int, c chan bool) {
			queens[column] = Queen{}
			queens[column].Init(width)
			queens[column].Run(column)
			c <- true
		}(column, c)
	}
	// waiting for all solutions
	for column := 0; column < width; column++ {
		<-c
	}

	var solutions [][]int
	for _, queen := range queens {
		for _, solution := range queen.solutions {
			solutions = append(solutions, solution)
		}
	}

	fmt.Printf("...took %f seconds.\n", time.Since(start).Seconds())
	fmt.Printf("...%d solutions found.\n", len(solutions))

	// for _, solution := range solutions {
	//	Dump(solution)
	//}
}
