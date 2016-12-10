/**
 * @author  Thomas Lehmann
 * @file    Queen.scala
 *
 * Copyright (c) 2016 Thomas Lehmann
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
import scala.collection.mutable.ListBuffer

object Queen {
    class Queen(initWidth: Int) {
        val width      : Int               = initWidth
        val lastRow    : Int               = width-1
        val lastColumn : Int               = width-1
        var columns    : Array[Int]        = new Array(width)
        var diagonals1 : Array[Int]        = null
        var diagonals2 : Array[Int]        = null
        var solutions  : ListBuffer[Array[Int]]  = new ListBuffer()

        {
            val numberOfDiagonals = 2 * width - 1

            diagonals1 = new Array(numberOfDiagonals)
            diagonals2 = new Array(numberOfDiagonals)

            for (index <- 0 to (numberOfDiagonals-1)) {
                if (index < width) {
                    columns(index) = -1
                }
                diagonals1(index) = 0
                diagonals2(index) = 0
            }
        }

        def run(row: Int) {
            for (column <- 0 to lastColumn) {
                if (columns(column) < 0) {
                    val ixDiag1 = row + column
                    if (diagonals1(ixDiag1) == 0) {
                        val ixDiag2 = lastRow - row + column
                        if (diagonals2(ixDiag2) == 0) {
                            columns(column)     = row
                            diagonals1(ixDiag1) = 1
                            diagonals2(ixDiag2) = 1

                            if (row == lastRow) {
                                solutions += columns.clone()
                            } else {
                                run(row+1)
                            }

                            columns(column)     = -1
                            diagonals1(ixDiag1) = 0
                            diagonals2(ixDiag2) = 0
                        }
                    }
                }
            }
        }

        def printAllSolutions() {
            for (solution <- solutions) {
                var text   = ""
                var column = 1
                for (row <- solution) {
                    text   += "(%d,%d)".format(column, row+1)
                    column += 1
                }
                println(text)
            }
        }
    }

    def main(arguments: Array[String]) {
        var width = 8

        if (arguments.length > 0) {
            width = arguments(0).toInt
        }

        val instance = new Queen(width)
        println("Queen raster (%dx%d)".format(width, width))
        val start = System.currentTimeMillis();
        instance.run(0)
        println("...took %f seconds.".format((System.currentTimeMillis() - start) / 1000.0))
        println("...%d solutions found.".format(instance.solutions.length))
        //instance.printAllSolutions()
    }
}
