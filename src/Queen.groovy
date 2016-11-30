/**
 * @author  Thomas Lehmann
 * @file    Queen.groovy
 *
 * Copyright (c) 2013 Thomas Lehmann
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
public class Queen {
    private width;
    private lastRow;
    private columns;
    private diagonals1;
    private diagonals2;
    private solutions;

    public Queen(width) {
        this.width      = width;
        this.lastRow    = this.width - 1;
        this.columns    = [];
        this.diagonals1 = [];
        this.diagonals2 = [];
        this.solutions  = [];

        def numberOfDiagonals = this.width * 2 - 1;
        for (def index = 0; index < numberOfDiagonals; ++index) {
            if (index < this.width) {
                this.columns += -1;
            }
            this.diagonals1 += false;
            this.diagonals2 += false;
        }
    }

    public getNumberOfSolutions() {
        return this.solutions.size();
    }

    public void runAlgorithm(row = 0) {
        for (def column = 0; column < this.width; ++column) {
            // is this column occupied?
            if (this.columns[column] >= 0) {
                continue;
            }

            def ixDiag1 = row + column;
            if (this.diagonals1[ixDiag1]) {
                continue;
            }

            def ixDiag2 = this.width - 1 - row + column;
            if (this.diagonals2[ixDiag2]) {
                continue;
            }

            this.columns[column] = row;
            this.diagonals1[ixDiag1] = true;
            this.diagonals2[ixDiag2] = true;

            if (row == this.lastRow) {
                this.solutions += [this.columns.clone()];
            } else {
                this.runAlgorithm(row+1);
            }

            this.columns[column] = -1;
            this.diagonals1[ixDiag1] = false;
            this.diagonals2[ixDiag2] = false;
        }
    }

    public printSolutions() {
        for (def solution in this.solutions) {
            for (def column = 0; column < this.width; ++column) {
                print "(${column+1},${solution[column]+1})";
            }
            print "\n";
        }
    }

    public static main(arguments) {
        def width = 8;

        if (arguments.length == 1) {
            width = arguments[0].toInteger();
        }

        Queen instance = new Queen(width);
        println "Queen raster (${width}x${width})";
        def start = System.currentTimeMillis();
        instance.runAlgorithm();
        println "...calculation took " + ((System.currentTimeMillis() - start) / 1000.0) + " seconds!";
        println "..." + instance.getNumberOfSolutions() + " solutions found!";
        //instance.printSolutions();
    }
}
