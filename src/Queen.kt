/**
 * @author  Thomas Lehmann
 * @file    Queen.kt
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
package algorithm

import java.util.ArrayList
import kotlin.system.measureTimeMillis

class Queen(val width: Int = 8) {
    val lastRow: Int = width - 1;
    var columns:    Array<Int> = Array<Int>(width, {i -> -1})
    var diagonals1: Array<Int> = Array<Int>(width*2-1, {i -> -1})
    var diagonals2: Array<Int> = Array<Int>(width*2-1, {i -> -1})
    var solutions:  MutableList<Array<Int>> = ArrayList<Array<Int>>()

    fun run(row: Int = 0) {
        for (column in 0..lastRow) {
            if (columns[column] >= 0) {
                continue;
            }

            val ixDiag1 = row + column
            if (diagonals1[ixDiag1] > 0) {
                continue;
            }

            val ixDiag2 = lastRow - row + column
            if (diagonals2[ixDiag2] > 0) {
                continue;
            }

            columns[column] = row;
            diagonals1[ixDiag1] = 1;
            diagonals2[ixDiag2] = 1;

            if (row == lastRow) {
                solutions.add(columns.clone());
            } else {
                run(row+1);
            }

            columns[column] = -1;
            diagonals1[ixDiag1] = 0;
            diagonals2[ixDiag2] = 0;
        }
    }
}

fun main(arguments: Array<String>) {
    var width: Int = 8;

    if (arguments.size == 1) {
        width = arguments[0].toInt();
    }

    var queen = Queen(width)
    println("Queen raster (${queen.width}x${queen.width})")
    val duration = measureTimeMillis {
        queen.run()
    }
    val solutions = queen.solutions.size;
    println("...took ${duration/1000.0} seconds.")
    println("...${solutions} solutions found.")
}
