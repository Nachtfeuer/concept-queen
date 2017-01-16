package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
)

// IsPrime checks for a given number {n} to be a prime.
func IsPrime(n int) bool {
	if n < 2 {
		return false
	}

	if n%2 == 0 {
		return n == 2
	}

	d := int(math.Sqrt(float64(n)))

	for k := 3; k <= d; k += 2 {
		if n%k == 0 {
			return false
		}
	}
	return true
}

// CreatePrimes provide all primes less or equal given number {maxN}.
func CreatePrimes(maxN int) chan int {
	c := make(chan int)
	go func() {
		c <- 2
		for n := 3; n <= maxN; n += 2 {
			if IsPrime(n) {
				c <- n
			}
		}
		close(c)
	}()
	return c
}

func main() {
	maxN := 100
	if len(os.Args) > 1 {
		maxN, _ = strconv.Atoi(os.Args[1])
	}

	for prime := range CreatePrimes(maxN) {
		fmt.Print(prime)
		fmt.Print(" ")
	}
}
