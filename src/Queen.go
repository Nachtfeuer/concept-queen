// Queen.go
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

func (q *Queen) Dump(solution []int) {
	for x, y := range solution {
		fmt.Printf("[%d, %d]", x+1, y+1)
	}
	fmt.Printf("\n")
}

func (q *Queen) Run(row int) {
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
			q.Run(row + 1)
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

	queen := Queen{}
	queen.Init(width)
	fmt.Printf("Queen raster (%dx%d)\n", queen.width, queen.width)

	start := time.Now()
	queen.Run(0)

	fmt.Printf("...took %f seconds\n", time.Since(start).Seconds())
	fmt.Printf("...%d solutions found\n", len(queen.solutions))

	//for _, solution := range queen.solutions {
	//	queen.Dump(solution)
	//}
}
